import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fluttair/database/preferences.dart';
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
      Preferences.prefs;
      dbProvider.database;
      fltProvider.flightPath;
      weatherProvider.weatherFile;
      notamsProvider.notamsFile;
      mapProvider.mapPath;
      setState(() {
        _message = Text('Database successfully loaded',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Fluttair!'),
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
