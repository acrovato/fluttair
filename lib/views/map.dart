import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:fluttair/database/preferences.dart';
import 'package:fluttair/database/map.dart';
import 'package:fluttair/database/flight.dart';
import 'package:fluttair/model/flight.dart';
import 'package:fluttair/model/map.dart';
import 'package:fluttair/utils/radio_dialog.dart';
import 'package:fluttair/utils/snackbar.dart';
import 'sidebar.dart';

class MapView extends StatefulWidget {
  final Flight flight;

  MapView({Key key, this.flight}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

// TODO check and understand how the different maps are loaded and persist in memory
// TODO ongoing notif: init outside and prevent from closing location stream
class MapViewState extends State<MapView> {
  // Map
  MapProvider _mapProvider = MapProvider();
  int _mapId = Preferences.getDefaultMap();

  // Location
  Location _locationService = Location();
  StreamSubscription<LocationData> _locationSubscription;
  LocationData _currentLocation;

  // Map controls
  MapController _mapController = MapController();
  bool _autoCentering = false;

  // Settings
  LatLng _homeBase = LatLng(50.85, 4.35); // TODO

  // Flight
  FlightProvider _flightProvider = FlightProvider();
  Flight _flight;
  bool _recording = false;

  // Notification
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    Wakelock.enable(); // keep the screen on
    _flight = widget.flight;
    _initLocation();
    // Notifications
    InitializationSettings initializationSettings = InitializationSettings(
        AndroidInitializationSettings('@mipmap/ic_launcher'),
        IOSInitializationSettings());
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    super.initState();
  }

  void dispose() {
    Wakelock.disable();
    if (_locationSubscription != null) _locationSubscription.cancel();
    super.dispose();
  }

  void _initLocation() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: Preferences.getGpsRefreshRate() * 1000);

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
      setState(() {
        _currentLocation = result;
        if (_recording && _currentLocation.speed > 5) // do not record if speed is less than taxi speed (10kts)
          _flight.record(_currentLocation.latitude, _currentLocation.longitude,
              _currentLocation.altitude);
        if (_autoCentering) _centerMap();
      });
    });
  }

  void _setFlight() {
    showDialog(
        context: context,
        builder: (BuildContext context) => RadioDialog(
            initial: _flight?.id ?? 0,
            data: _flightProvider.getFlights(),
            onChoiceChanged: _onFlightChanged,
            title: 'Set flight'));
  }

  void _onFlightChanged(int id) async {
    setState(() => _flight = _flightProvider.getFlight(id));
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

  Future<void> _startRecord() async {
    // Start recording
    _recording = true;
    // Create flight if needed
    if (_flight == null) {
      int id = await _flightProvider.createFlight();
      _flight = _flightProvider.getFlight(id);
    }
    // Create ongoing notification
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('id', 'name', 'desc',
            importance: Importance.Max,
            priority: Priority.High,
            ongoing: true,
            autoCancel: false);
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, IOSNotificationDetails());
    await _flutterLocalNotificationsPlugin.show(
        0, 'Fluttair', 'Recording flight', platformChannelSpecifics);
  }

  Future<void> _stopRecord() async {
    // Stop recording
    _recording = false;
    // Cancel notification
    await _flutterLocalNotificationsPlugin.cancel(0);
    _flightProvider.saveFlight(_flight);
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
          width: 60,
          height: 60,
          point: LatLng(_currentLocation.latitude, _currentLocation.longitude),
          builder: (context) => LayoutBuilder(
              builder: (context, constraint) => Transform.rotate(
                  angle: _currentLocation.heading * math.pi / 180.0,
                  child: Icon(Icons.airplanemode_active,
                      color: Colors.indigo,
                      size: constraint.biggest.height)))));
    }
    return posit;
  }

  Polyline _getVector() {
    List<LatLng> vector = [];
    if (_currentLocation != null) {
      LatLng p0 = LatLng(_currentLocation.latitude, _currentLocation.longitude);
      LatLng p1 = Distance().offset(p0, _currentLocation.speed * 5.0 * 60.0,
          _currentLocation.heading); // 5-minutes distance
      vector.add(p0);
      vector.add(p1);
    }
    return Polyline(
        points: vector, strokeWidth: 4.0, color: Colors.green, isDotted: true);
  }

  List<Marker> _getRouteMark() {
    List<Marker> route = [];
    if (_flight != null) {
      route.length = _flight.steerpoints.length;
      for (int i = 0; i < _flight.steerpoints.length; ++i) {
        route[i] = Marker(
            point: _flight.steerpoints[i],
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
    return Polyline(
        points: _flight?.steerpoints ?? [],
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
          icon:
              _recording ? Icon(Icons.stop) : Icon(Icons.radio_button_checked),
          color: Colors.redAccent,
          splashColor: Colors.redAccent,
          onPressed: () async {
            if (!_recording)
              _startRecord();
            else
              _stopRecord();
            setState(() {});
          },
        ),
        PopupMenuButton<int>(
            onSelected: _choiceAction,
            itemBuilder: (BuildContext context) => _actions)
      ],
    );
  }

  Row _gpsRow() {
    List<String> data = List(3);
    if (_currentLocation != null) {
      data[0] = (_currentLocation.speed * Preferences.getSpeedFactor())
              .round()
              .toString() +
          ' ${Preferences.getSpeedUnit()}';
      data[1] = (_currentLocation.heading).round().toString() + ' °';
      data[2] = (_currentLocation.altitude * Preferences.getAltitudeFactor())
              .round()
              .toString() +
          ' ${Preferences.getAltitudeUnit()}';
    } else {
      data[0] = '--- ${Preferences.getSpeedUnit()}';
      data[1] = '--- °';
      data[2] = '--- ${Preferences.getAltitudeUnit()}';
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
                          MarkerLayerOptions(markers: _getRouteMark()),
                          PolylineLayerOptions(polylines: [_getRoute()]),
                          MarkerLayerOptions(markers: _getPositMark()),
                          PolylineLayerOptions(polylines: [_getVector()])
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
          _gpsRow()
        ])));
  }
}
