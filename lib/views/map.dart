import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';

import 'package:fluttair/model/flights.dart';
import 'package:fluttair/utils/snackbar.dart';
import 'sidebar.dart';

class MapView extends StatefulWidget {
  MapView({Key key}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

// TODO keep screen awake unless power button
// TODO add dropdown menu or load flight action
class MapViewState extends State<MapView> {
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
  Flight _flight;
  bool _recording = false;

  @override
  void initState() {
    _initLocation();
    _flight = Flight(id: 1000000);
    _flight.steerpoints = [
      LatLng(50.65, 5.45),
      LatLng(50.70, 4.40),
      LatLng(51.20, 2.87)
    ];
    super.initState();
  }

  void dispose() {
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

  void _centerMap() {
    if (_currentLocation != null)
      _mapController.move(
          LatLng(_currentLocation.latitude, _currentLocation.longitude),
          _mapController.zoom);
  }

  List<Marker> _buildPsMarker() {
    if (_currentLocation != null) {
      List<Marker> posit = List(1);
      posit[0] = Marker(
        point: LatLng(_currentLocation.latitude, _currentLocation.longitude),
        builder: (context) => Container(
            child: Transform.rotate(
                angle: _currentLocation.heading * math.pi / 180.0,
                child: Icon(
                  Icons.airplanemode_active,
                  color: Colors.indigo,
                  size: 60,
                ))),
      );
      return posit;
    } else
      return [];
  }

  List<Marker> _buildRtMarker() {
    if (_flight != null) {
      List<Marker> route = List(_flight.steerpoints.length);
      for (int i = 0; i < _flight.steerpoints.length; ++i) {
        route[i] = Marker(
            point: _flight.steerpoints[i],
            builder: (context) => Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.purple,
                  size: 30,
                ));
      }
      return route;
    } else
      return [];
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
        appBar: AppBar(
          title: Text('Map'),
          actions: <Widget>[
            IconButton(
              icon: _recording
                  ? Icon(Icons.radio_button_unchecked)
                  : Icon(Icons.radio_button_checked),
              color: Colors.redAccent,
              splashColor: Colors.redAccent,
              onPressed: () {
                setState(() {
                  if (!_recording) {
                    if (_flight == null) _flight = Flight(id: 1000000);
                    _recording = _flight.record();
                  } else
                    _recording = _flight.stop();
                });
              },
            )
          ],
        ),
        body: Card(
            child: Column(children: <Widget>[
          Flexible(
              child: Stack(
            children: <Widget>[
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: _homeBase,
                  minZoom: 6.0,
                  maxZoom: 12.0,
                  zoom: 8.0,
                ),
                layers: [
                  // Offline
                  TileLayerOptions(
                    tms: true,
                    tileProvider: MBTilesImageProvider.fromAsset(
                        'assets/maps/ofm_ebbu.mbtiles'),
                  ),
                  MarkerLayerOptions(markers: _buildPsMarker()),
                  MarkerLayerOptions(markers: _buildRtMarker()),
                  PolylineLayerOptions(
                    polylines: [
                      Polyline(
                          points: _flight?.steerpoints ?? [],
                          strokeWidth: 4.0,
                          color: Colors.purple),
                    ],
                  )
                ],
              ),
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
                child: Text('© OpenTileMap, OpenStreetMap contributors',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
                alignment: Alignment.bottomLeft,
              )
            ],
          )),
          _buildRow()
        ])));
  }
}
