import 'package:flutter/material.dart';

import 'package:fluttair/database/flight.dart';
import 'package:fluttair/model/flights.dart';

class FlightView extends StatefulWidget {
  Flight flight;

  FlightView({Key key, @required this.flight}) : super(key: key);

  @override
  FlightViewState createState() => FlightViewState();
}

class FlightViewState extends State<FlightView> {
  final FlightProvider _flightProvider = FlightProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: BackButton(), title: Text('Edit flight')),
        body: Stack(children: <Widget>[
          ListView(
            // TODO add textfield + controllers
            children: <Widget>[
              Card(child: Text(widget.flight.name)),
              Card(
                  child: Row(children: <Widget>[
                Text(widget.flight.departure,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor)),
                Icon(Icons.arrow_right),
                Text(widget.flight.arrival,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor))
              ])),
              Card(child: Text('aaa\naaaaa\naaaa'))
            ],
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                      child: Icon(Icons.save),
                      onPressed: () {
                        _flightProvider.saveFlight(widget.flight);
                        setState(() {});
                      })))
        ]));
  }
}
