import 'package:fluttair/model/airport.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

import 'package:fluttair/database/local.dart';
import 'package:fluttair/database/flight.dart';
import 'package:fluttair/model/flight.dart';
import 'package:fluttair/utils/snackbar.dart';
import 'package:fluttair/views/map.dart';

class FlightView extends StatefulWidget {
  final Flight flight;

  FlightView({Key key, @required this.flight}) : super(key: key);

  @override
  FlightViewState createState() => FlightViewState();
}

class FlightViewState extends State<FlightView> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final FlightProvider _flightProvider = FlightProvider();
  TextEditingController nameController = TextEditingController();
  TextEditingController departureController = TextEditingController();
  TextEditingController arrivalController = TextEditingController();
  TextEditingController steerController = TextEditingController();
  List<FocusNode> focuses = [FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    nameController.text = widget.flight.name;
    departureController.text = widget.flight.departure;
    arrivalController.text = widget.flight.arrival;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    departureController.dispose();
    arrivalController.dispose();
    steerController.dispose();
    for (var focus in focuses) focus.dispose();
    super.dispose();
  }

  Widget _inputBar1(TextEditingController controller, String label, int field) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: TextField(
            focusNode: focuses[field],
            autofocus: field == 0 ? true : false,
            textCapitalization: field != 0
                ? TextCapitalization.characters
                : TextCapitalization.none,
            controller: controller,
            onSubmitted: (value) {
              _setField(controller.text, field);
              if (field < 2)
                FocusScope.of(context).requestFocus(focuses[field + 1]);
            },
            textInputAction:
                field != 2 ? TextInputAction.next : TextInputAction.done,
            decoration: InputDecoration(
              labelText: label,
              contentPadding: EdgeInsets.all(12.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            )));
  }

  void _setField(String input, int field) async {
    if (field == 0) {
      widget.flight.name = input;
    } else {
      Airport airport = await DatabaseProvider().getAirport(input);
      if (airport != null) {
        setState(() {
          if (field == 1) {
            widget.flight.departure = airport.icao;
            widget.flight.steerpoints.isEmpty
                ? widget.flight.steerpoints
                    .add(LatLng(airport.latitude, airport.longitude))
                : widget.flight.steerpoints[0] =
                    LatLng(airport.latitude, airport.longitude);
          } else if (field == 2) {
            widget.flight.arrival = airport.icao;
            widget.flight.steerpoints.length <= 1
                ? widget.flight.steerpoints
                    .add(LatLng(airport.latitude, airport.longitude))
                : widget.flight
                        .steerpoints[widget.flight.steerpoints.length - 1] =
                    LatLng(airport.latitude, airport.longitude);
          }
        });
      } else
        _scaffoldKey.currentState
            .showSnackBar(snackBar('Airport ICAO not found'));
    }
  }

  Widget _inputBar2(TextEditingController controller) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: TextField(
            focusNode: FocusNode(),
            autofocus: false,
            controller: controller,
            onSubmitted: (value) => _addSteer(controller.text),
            decoration: InputDecoration(
              labelText: 'Add steerpoint',
              hintText: '0.0, 0.0',
              prefixIcon: Icon(Icons.add),
              contentPadding: EdgeInsets.all(12.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            )));
  }

  void _addSteer(String input) {
    if (input != null) {
      try {
        List<double> coord = input.split(',').map(double.parse).toList();
        if (coord.length == 2)
          setState(() => widget.flight.steerpoints.insert(
              widget.flight.steerpoints.length - 1,
              LatLng(coord[0], coord[1])));
        else
          _scaffoldKey.currentState.showSnackBar(snackBar(
              'Format error: please enter latitude and longitude separated by a comma (eg: 1.2,3.4)'));
      } catch (_) {
        _scaffoldKey.currentState.showSnackBar(snackBar(
            'Format error: please enter latitude and longitude separated by a comma (eg: 1.2,3.4)'));
      }
    }
  }

  void _removeSteer(int i) {
    setState(() => widget.flight.steerpoints.removeAt(i));
  }

  Widget _steerIcon(int i) {
    if (i == 0)
      return Icon(Icons.flight_takeoff);
    else if (i == widget.flight.steerpoints.length - 1)
      return Icon(Icons.flight_land);
    else
      return IconButton(
          icon: Icon(Icons.remove, color: Colors.redAccent),
          onPressed: () => _removeSteer(i));
  }

  void _saveFlight() {
    // Safety set (in case the user did not use the keyboard action button) then save
    widget.flight.name = nameController.text;
    widget.flight.departure = departureController.text;
    widget.flight.arrival = arrivalController.text;
    _flightProvider.saveFlight(widget.flight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: BackButton(),
          title: Text('Edit flight'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveFlight();
                setState(() {});
              },
            )
          ],
        ),
        body: Stack(children: <Widget>[
          ListView(shrinkWrap: true, children: <Widget>[
            Card(
                child: Column(children: <Widget>[
              ListTile(
                  title: Text('Details',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              _inputBar1(nameController, 'Flight name', 0),
              Row(children: <Widget>[
                Expanded(
                    child: _inputBar1(departureController, 'Departure', 1)),
                Icon(Icons.arrow_right),
                Expanded(child: _inputBar1(arrivalController, 'Arrival', 2))
              ])
            ])),
            Card(
                child: Column(children: <Widget>[
              ListTile(
                title: Text('Route',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.flight.steerpoints.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        title: Text(
                            '${widget.flight.steerpoints[i].latitude}, ${widget.flight.steerpoints[i].longitude}'),
                        leading: _steerIcon(i),
                      );
                    }),
              ),
              _inputBar2(steerController)
            ]))
          ]),
          Padding(
              padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                      child: Icon(Icons.flight_takeoff),
                      onPressed: () {
                        _saveFlight();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MapView(flightId: widget.flight.id)));
                      })))
        ]));
  }
}
