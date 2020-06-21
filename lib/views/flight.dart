import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:fluttair/database/preferences.dart';
import 'package:fluttair/database/map.dart';
import 'package:fluttair/database/local.dart';
import 'package:fluttair/database/flight.dart';
import 'package:fluttair/model/flight.dart';
import 'package:fluttair/model/map.dart';
import 'package:fluttair/model/airport.dart';
import 'package:fluttair/utils/snackbar.dart';
import 'package:fluttair/views/map.dart';

/// Planned flight
class FlightPlanView extends StatefulWidget {
  final Flight flight;

  FlightPlanView({Key key, @required this.flight}) : super(key: key);

  @override
  FlightPlanViewState createState() => FlightPlanViewState();
}

class FlightPlanViewState extends State<FlightPlanView> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final FlightProvider _flightProvider = FlightProvider();
  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  TextEditingController steerController = TextEditingController();
  List<FocusNode> focuses = [FocusNode(), FocusNode(), FocusNode()];
  FocusNode steerFocus = FocusNode();

  @override
  void initState() {
    controllers[0].text = widget.flight.name;
    controllers[1].text = widget.flight.departure;
    controllers[2].text = widget.flight.arrival;
    super.initState();
  }

  @override
  void dispose() {
    for (var control in controllers) control.dispose();
    steerController.dispose();
    for (var focus in focuses) focus.dispose();
    steerFocus.dispose();
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
              hintText: field == 0 ? label : 'ICAO',
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

  Widget _inputBar2(TextEditingController controller, FocusNode node) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: TextField(
            focusNode: node,
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
        if (widget.flight.steerpoints.length >= 2) {
          List<double> coord = input.split(',').map(double.parse).toList();
          if (coord.length == 2 && coord[0].isFinite && coord[1].isFinite)
            setState(() => widget.flight.steerpoints.insert(
                widget.flight.steerpoints.length - 1,
                LatLng(coord[0], coord[1])));
          else
            _scaffoldKey.currentState.showSnackBar(snackBar(
                'Format error: please enter latitude and longitude separated by a comma (eg: 1.2,3.4)'));
        } else
          _scaffoldKey.currentState.showSnackBar(
              snackBar('Please enter departure and arrival airport first'));
      } catch (e) {
        _scaffoldKey.currentState
            .showSnackBar(snackBar('Error ' + e.toString()));
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
    widget.flight.name = controllers[0].text;
    widget.flight.departure = controllers[1].text;
    widget.flight.arrival = controllers[2].text;
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
              _inputBar1(controllers[0], 'Flight name', 0),
              Row(children: <Widget>[
                Expanded(child: _inputBar1(controllers[1], 'Departure', 1)),
                Icon(Icons.arrow_right),
                Expanded(child: _inputBar1(controllers[2], 'Arrival', 2))
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
              _inputBar2(steerController, steerFocus)
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
                                    MapView(flight: widget.flight)));
                      })))
        ]));
  }
}

// TODO maybe move to separate view
/// Archived flight
class FlightArchiveView extends StatefulWidget {
  final Flight flight;

  FlightArchiveView({Key key, @required this.flight}) : super(key: key);

  @override
  FlightArchiveViewState createState() => FlightArchiveViewState();
}

// TODO rework duplicate and allow more control
class FlightArchiveViewState extends State<FlightArchiveView> {
  MapProvider _mapProvider = MapProvider();
  MapController _mapController = MapController();
  int _mapId = Preferences.getDefaultMap(); //TODO
  LatLng _homeBase = LatLng(50.85, 4.35); // TODO

  // TODO group with altitude?
  int _getDistance() {
    double dist = 0;
    for (int i = 0; i < widget.flight.track.length - 1; ++i) {
      LatLng p0 = LatLng(
          widget.flight.track[i].latitude, widget.flight.track[i].longitude);
      LatLng p1 = LatLng(widget.flight.track[i + 1].latitude,
          widget.flight.track[i + 1].longitude);
      dist += Distance().distance(p0, p1);
    }
    return (dist / 1852).ceil(); // in nm
  }

  int _getDuration() {
    if (widget.flight.track.isNotEmpty)
      return widget.flight.track.last.time
          .difference(widget.flight.track.first.time)
          .inMinutes;
    else
      return 0;
  }

  // TODO rework that shi**
  List<charts.Series<MapEntry<double, int>, double>> _getAltitude() {
    List<MapEntry<double, int>> alt = []; // TODO maybe use a class?
    if (widget.flight.track.isNotEmpty) {
      alt.add(
          MapEntry(0, (widget.flight.track.first.altitude * 3.281).toInt()));
      for (int i = 1; i < widget.flight.track.length; ++i) {
        LatLng p0 = LatLng(widget.flight.track[i - 1].latitude,
            widget.flight.track[i - 1].longitude);
        LatLng p1 = LatLng(
            widget.flight.track[i].latitude, widget.flight.track[i].longitude);
        alt.add(MapEntry(alt[i - 1].key + Distance().distance(p0, p1) / 1852,
            (widget.flight.track[i].altitude * 3.281).toInt()));
      }
    }
    return [
      charts.Series<MapEntry<double, int>, double>(
          id: 'altitude',
          domainFn: (MapEntry<double, int> data, _) => data.key,
          measureFn: (MapEntry<double, int> data, _) => data.value,
          data: alt)
    ];
  }

  //TODO duplicate
  List<Marker> _getRouteMark() {
    List<Marker> route = [];
    route.length = widget.flight.steerpoints.length;
    for (int i = 0; i < widget.flight.steerpoints.length; ++i) {
      route[i] = Marker(
          point: widget.flight.steerpoints[i],
          builder: (context) => Icon(
                Icons.radio_button_unchecked,
                color: Colors.purple,
                size: 30,
              ));
    }
    return route;
  }

  // TODO duplicate
  Polyline _getRoute() {
    return Polyline(
        points: widget.flight.steerpoints ?? [],
        strokeWidth: 4.0,
        color: Colors.purple);
  }

  Polyline _getTrack() {
    List<LatLng> track = [];
    for (var pos in widget.flight.track)
      track.add(LatLng(pos.latitude, pos.longitude));
    return Polyline(points: track, strokeWidth: 4.0, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(), title: Text('View ${widget.flight.name}')),
        body: Column(children: <Widget>[
          ListTile(
              title: Row(children: <Widget>[
                Text(widget.flight.departure,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor)),
                Icon(Icons.arrow_right),
                Text(widget.flight.arrival,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor))
              ]),
              subtitle: Text('Distance: ${_getDistance()} nm\n'
                  'Duration: ${_getDuration()} min')),
          Expanded(
              flex: 3,
              child: Stack(children: <Widget>[
                FutureBuilder(
                    future: _mapProvider.getMap(_mapId),
                    builder:
                        (BuildContext context, AsyncSnapshot<MyMap> snapshot) {
                      if (snapshot.hasData) {
                        return FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: widget.flight.steerpoints.isEmpty
                                ? _homeBase
                                : widget.flight.steerpoints[0],
                            minZoom: 6.0,
                            maxZoom: 12.0,
                            zoom: 8.0,
                          ),
                          layers: [
                            TileLayerOptions(
                                tms: true,
                                tileProvider: MBTilesImageProvider.fromFile(
                                    snapshot.data.file)),
                            MarkerLayerOptions(markers: _getRouteMark()),
                            PolylineLayerOptions(
                                polylines: [_getRoute(), _getTrack()])
                          ],
                        );
                      } else if (snapshot.hasError)
                        return Container(
                            child: Text(snapshot.error.toString()),
                            margin: EdgeInsets.all(10));
                      else
                        return Center(child: CircularProgressIndicator());
                    }),
                Align(
                  child: Text('© OpenFlightMap',
                      //\n© OpenTileMap, OpenStreetMap contributors',
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                  alignment: Alignment.bottomLeft,
                )
              ])),
          Flexible(
              child: charts.LineChart(_getAltitude(),
                  domainAxis: charts.NumericAxisSpec(
                      renderSpec: charts.SmallTickRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                              color: charts.ColorUtil.fromDartColor(
                                  Theme.of(context).textTheme.title.color)),
                          lineStyle: charts.LineStyleSpec(
                              color: charts.ColorUtil.fromDartColor(
                                  Theme.of(context).textTheme.title.color)))),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                      renderSpec: charts.GridlineRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                              color: charts.ColorUtil.fromDartColor(Theme.of(context).textTheme.title.color)),
                          lineStyle: charts.LineStyleSpec(color: charts.ColorUtil.fromDartColor(Theme.of(context).textTheme.title.color))))))
        ]));
  }
}
