import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttair/database/local.dart';
import 'package:fluttair/database/flight.dart';
import 'package:fluttair/database/internet.dart';
import 'package:fluttair/database/map.dart';

/// Splash screen
class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  Text _message;

  @override
  void initState() {
    _message = Text('Loading data...');
    _initPrefs();
    _checkData();
    super.initState();
  }

  void _checkData() {
    DatabaseProvider dbProvider = DatabaseProvider();
    FlightProvider fltProvider = FlightProvider();
    WeatherProvider weatherProvider = WeatherProvider();
    NotamsProvider notamsProvider = NotamsProvider();
    MapProvider mapProvider = MapProvider();
    try {
      dbProvider.database;
      fltProvider.flightPath;
      weatherProvider.weatherFile;
      notamsProvider.notamsFile;
      mapProvider.mapPath;
      setState(() {
        _message = Text('Database sucessfully loaded',
            style: TextStyle(color: Colors.green));
      });
      Timer(const Duration(milliseconds: 500),
          () => Navigator.of(context).pushReplacementNamed('/flights'));
    } on FileSystemException catch (e) {
      setState(() {
        _message = Text('Error while loading database\n' + e.toString(),
            style: TextStyle(color: Colors.red));
      });
    }
  }

  void _initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('dark_mode') == null) prefs.setBool('dark_mode', false);
    if (prefs.getInt('default_map') == null) prefs.setInt('default_map', 0);
    if (prefs.getInt('gps_refresh') == null) prefs.setInt('gps_refresh', 10);
    if (prefs.getString('map_units_speed') == null)
      prefs.setString('map_units_speed', 'kts');
    if (prefs.getString('map_units_altitude') == null)
      prefs.setString('map_units_altitude', 'ft');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome to FluttAir!'),
        ),
        body: Stack(children: <Widget>[
          Center(child: FlutterLogo(size: 128)),
          Align(
              child: Container(
                constraints: BoxConstraints(maxWidth: 250.0),
                child: Row(children: <Widget>[
                  CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor)),
                  _message
                ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                margin: EdgeInsets.all(20),
              ),
              alignment: Alignment.bottomCenter)
        ]));
  }
}
