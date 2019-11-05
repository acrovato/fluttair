import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fluttair/model/database.dart';

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
    // TODO: display message on screen (from database)
    dbProvider.database;
    Timer(Duration(seconds: 3), () {
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
