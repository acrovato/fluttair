import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';

import 'sidebar.dart';

class MapView extends StatefulWidget {
  MapView({Key key}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

// TODO refactor: can the location be separated from the map?
class MapViewState extends State<MapView> {
  MapController _mapController = MapController();
  Location _locationService = Location();
  StreamSubscription<LocationData> _locationSubscription;
  LocationData _currentLocation;
  bool _autoCentering;
  List<Marker> _posit = List(1);

  var route = <LatLng>[
    LatLng(50.65, 5.45),
    LatLng(50.70, 4.40),
    LatLng(51.20, 2.87)
  ];

  @override
  void initState() {
    _posit[0] = Marker(
        point: LatLng(0.0, 0.0),
        builder: (context) => Container(width: 0.0, height: 0.0));
    _initLocation();
    super.initState();
  }

  void dispose() {
    if (_locationSubscription != null) _locationSubscription.cancel();
    super.dispose();
  }

  void _initLocation() async {
    _autoCentering = true;
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 5000); // TODO allow to change refresh rate

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
      if (e.code == 'PERMISSION_DENIED') {
        Scaffold.of(context)
            .showSnackBar(_getSnack('Access to Location denied'));
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        Scaffold.of(context).showSnackBar(_getSnack('Location status error'));
      }
    }
  }

  // TODO move to utils
  SnackBar _getSnack(String message) {
    return SnackBar(
      content: Text(message),
    );
  }

  void _subscribeToLocation() {
    _locationSubscription =
        _locationService.onLocationChanged().listen((LocationData result) {
      setState(() {
        _currentLocation = result;
        _posit[0] = _buildMarker();
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

  Marker _buildMarker() {
    if (_currentLocation != null)
      return Marker(
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
    else
      return Marker(
          point: LatLng(0.0, 0.0),
          builder: (context) => Container(width: 0.0, height: 0.0));
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
          _buildColumn('G/S', data[0]),
          _buildColumn('HDG', data[1]),
          _buildColumn('ALT', data[2])
        ]);
  }

  Column _buildColumn(String title, String data) {
    return Column(children: <Widget>[Text(title), Text(data)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text('Map'),
          actions: <Widget>[
            // TODO
            IconButton(
              icon: true
                  ? Icon(Icons.radio_button_checked)
                  : Icon(Icons.radio_button_unchecked),
              color: Colors.redAccent,
              splashColor: Colors.redAccent,
              //iconSize: MediaQuery.of(context).size.height * 0.05,
              onPressed: () {},
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
                  center: LatLng(50.85, 4.35),
                  // TODO: Brussels location -> set to homebase
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
                  MarkerLayerOptions(markers: _posit),
                  PolylineLayerOptions(
                    polylines: [
                      Polyline(
                          points: route,
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
                              setState(() {
                                if (_autoCentering && _currentLocation != null)
                                  _autoCentering = false;
                                else {
                                  _autoCentering = true;
                                  _centerMap();
                                }

                              });
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
