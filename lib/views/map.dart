import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'package:wakelock/wakelock.dart';

import 'package:fluttair/database/map.dart';
import 'package:fluttair/database/flight.dart';
import 'package:fluttair/model/flights.dart';
import 'package:fluttair/model/map.dart';
import 'package:fluttair/utils/radio_dialog.dart';
import 'package:fluttair/utils/snackbar.dart';
import 'sidebar.dart';

class MapView extends StatefulWidget {
  final int flightId;

  MapView({Key key, this.flightId}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

// TODO check and understand how the different maps are loaded and persist in memory
// TODO keep screen awake unless power button + ongoing notification
class MapViewState extends State<MapView> {
  // Map
  MapProvider _mapProvider = MapProvider();
  int _mapId;

  // Location
  Location _locationService = Location();
  StreamSubscription<LocationData> _locationSubscription;
  LocationData _currentLocation;

  // Map controls
  MapController _mapController = MapController();
  bool _autoCentering = false;

  // Settings
  int _refreshRate = 5;
  LatLng _homeBase = LatLng(50.85, 4.35);

  // Flight
  FlightProvider _flightProvider = FlightProvider();
  int _flightId;
  bool _recording = false;

  @override
  void initState() {
    Wakelock.enable(); // keep the screen on
    _onMapChanged(0); // TODO should come from settings
    _flightId = widget.flightId;
    _initLocation();
    super.initState();
  }

  void dispose() {
    Wakelock.disable();
    if (_locationSubscription != null) _locationSubscription.cancel();
    super.dispose();
  }

  void _initLocation() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.NAVIGATION, interval: _refreshRate * 1000);

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool permission = await _locationService.requestPermission();
      print("Permission: $permission");
      if (permission) {
        bool serviceStatus = await _locationService.serviceEnabled();
        print("Service status: $serviceStatus");
        if (serviceStatus)
          _subscribeToLocation();
        else {
          bool serviceStatusResult = await _locationService.requestService();
          print("Service status activated after request: $serviceStatusResult");
          if (serviceStatusResult) _subscribeToLocation();
        }
      }
    } on PlatformException catch (e) {
      print(e.toString());
      Scaffold.of(context).showSnackBar(snackBar(e.message));
    }
  }

  void _subscribeToLocation() {
    setState(() => _autoCentering = true);
    _locationSubscription =
        _locationService.onLocationChanged().listen((LocationData result) {
      if (mounted)
        setState(() {
          _currentLocation = result;
          if (_autoCentering) _centerMap();
        });
    });
  }

  void _setFlight() {
    showDialog(
        context: context,
        builder: (BuildContext context) => RadioDialog(
            initial: _flightId,
            data: _flightProvider.getFlights(),
            onChoiceChanged: _onFlightChanged,
            title: 'Set flight'));
  }

  void _onFlightChanged(int id) async {
    setState(() => _flightId = id);
  }

  void _setMap() {
    showDialog(
        context: context,
        builder: (BuildContext context) => RadioDialog(
            initial: _mapId,
            data: _mapProvider.getMaps(),
            onChoiceChanged: _onMapChanged,
            title: 'Set map'));
  }

  void _onMapChanged(int id) async {
    setState(() => _mapId = id);
  }

  void _centerMap() {
    if (_currentLocation != null)
      _mapController.move(
          LatLng(_currentLocation.latitude, _currentLocation.longitude),
          _mapController.zoom);
  }

  List<Marker> _getPositMark() {
    List<Marker> posit = [];
    if (_currentLocation != null) {
      posit.add(Marker(
        point: LatLng(_currentLocation.latitude, _currentLocation.longitude),
        builder: (context) => Container(
            child: Transform.rotate(
                angle: _currentLocation.heading * math.pi / 180.0,
                child: Icon(
                  Icons.airplanemode_active,
                  color: Colors.indigo,
                  size: 60,
                ))),
      ));
    }
    return posit;
  }

  List<Marker> _getRouteMark() {
    Flight flight;
    _flightId != null
        ? flight = _flightProvider.getFlight(_flightId)
        : flight = null;
    List<Marker> route = [];
    if (flight != null) {
      route.length = flight.steerpoints.length;
      for (int i = 0; i < flight.steerpoints.length; ++i) {
        route[i] = Marker(
            point: flight.steerpoints[i],
            builder: (context) => Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.purple,
                  size: 30,
                ));
      }
    }
    return route;
  }

  Polyline _getRoute() {
    Flight flight;
    _flightId != null
        ? flight = _flightProvider.getFlight(_flightId)
        : flight = null;
    return Polyline(
        points: flight?.steerpoints ?? [],
        strokeWidth: 4.0,
        color: Colors.purple);
  }

  Widget _appBar() {
    List<PopupMenuItem<int>> _actions = List(2);
    _actions[0] = PopupMenuItem<int>(child: Text('Set map'), value: 0);
    _actions[1] = PopupMenuItem<int>(child: Text('Set flight'), value: 1);

    void _choiceAction(int choice) {
      if (choice == 0)
        setState(() => _setMap());
      else if (choice == 1) setState(() => _setFlight());
    }

    return AppBar(
      title: Text('Map'),
      actions: <Widget>[
        IconButton(
          icon: _recording
              ? Icon(Icons.radio_button_unchecked)
              : Icon(Icons.radio_button_checked),
          color: Colors.redAccent,
          splashColor: Colors.redAccent,
          onPressed: () async {
            if (_flightId == null)
              _flightId = await _flightProvider.createFlight();
            setState(() {
              if (!_recording) {
                _recording = true;
              } else
                _recording = false;
            });
          },
        ),
        PopupMenuButton<int>(
            onSelected: _choiceAction,
            itemBuilder: (BuildContext context) => _actions)
      ],
    );
  }

  Row _buildRow() {
    List<String> data = List(3);
    if (_currentLocation != null) {
      data[0] = (_currentLocation.speed * 1.944).round().toString() + ' kts';
      data[1] = (_currentLocation.heading).round().toString() + ' °';
      data[2] = (_currentLocation.altitude * 3.281).round().toString() + ' ft';
    } else {
      data[0] = '--- kts';
      data[1] = '--- °';
      data[2] = '--- ft';
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(children: <Widget>[Text('G/S'), Text(data[0])]),
          Column(children: <Widget>[Text('HDG'), Text(data[1])]),
          Column(children: <Widget>[Text('ALT'), Text(data[2])]),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: _appBar(),
        body: Card(
            child: Column(children: <Widget>[
          Flexible(
              child: Stack(
            children: <Widget>[
              FutureBuilder(
                  future: _mapProvider.getMap(_mapId),
                  builder:
                      (BuildContext context, AsyncSnapshot<MyMap> snapshot) {
                    if (snapshot.hasData) {
                      return FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          center: _homeBase,
                          minZoom: 6.0,
                          maxZoom: 12.0,
                          zoom: 8.0,
                        ),
                        layers: [
                          TileLayerOptions(
                              tms: true,
                              tileProvider: MBTilesImageProvider.fromFile(
                                  snapshot.data.file)),
                          MarkerLayerOptions(markers: _getPositMark()),
                          MarkerLayerOptions(markers: _getRouteMark()),
                          PolylineLayerOptions(
                            polylines: [_getRoute()],
                          )
                        ],
                      );
                    } else if (snapshot.hasError)
                      return Container(
                          child: Text(snapshot.error.toString()),
                          margin: EdgeInsets.all(10));
                    else
                      return Center(child: CircularProgressIndicator());
                  }),
              Padding(
                  padding: EdgeInsets.only(bottom: 16.0, right: 8.0, top: 8.0),
                  child: Align(
                      child: Column(children: <Widget>[
                        FloatingActionButton(
                            heroTag: 'layers',
                            child: Icon(Icons.layers),
                            onPressed: () {}),
                        FloatingActionButton(
                            heroTag: 'position', // filter_center_focus
                            child: _autoCentering
                                ? Icon(Icons.center_focus_strong)
                                : Icon(Icons.my_location),
                            onPressed: () {
                              if (_locationSubscription == null)
                                _initLocation();
                              else {
                                if (_currentLocation != null) {
                                  setState(() {
                                    if (_autoCentering)
                                      _autoCentering = false;
                                    else {
                                      _autoCentering = true;
                                      _centerMap();
                                    }
                                  });
                                }
                              }
                            })
                      ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                      alignment: Alignment.centerRight)),
              Align(
                child: Text(
                    '© OpenFlightMap\n© OpenTileMap, OpenStreetMap contributors',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
                alignment: Alignment.bottomLeft,
              )
            ],
          )),
          _buildRow()
        ])));
  }
}
