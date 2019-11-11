import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fluttair/database/local.dart';
import 'package:fluttair/database/internet.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    checkData();
  }

  checkData() {
    DatabaseProvider dbProvider = DatabaseProvider();
    WeatherProvider weatherProvider = WeatherProvider();
    NotamsProvider notamsProvider = NotamsProvider();
    // TODO: display message on screen (from database)
    dbProvider.database;
    weatherProvider.weatherFile;
    notamsProvider.notamsFile;
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacementNamed('/flights');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome to FluttAir!'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor)),
          Text('Loading data...')
        ], mainAxisAlignment: MainAxisAlignment.center)));
  }
}
