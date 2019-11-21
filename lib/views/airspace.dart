import 'package:flutter/material.dart';

import 'package:fluttair/model/airspace.dart';

/// Airspace view
class AirspaceView extends StatefulWidget {
  final Airspace airspace;

  AirspaceView({Key key, @required this.airspace}) : super(key: key);

  @override
  AirspaceViewState createState() => AirspaceViewState();
}

class AirspaceViewState extends State<AirspaceView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            leading: BackButton(),
            title: Text(widget.airspace.name),
          ),
          body: ListView(children: <Widget>[
            Card(
                child: ListTile(
                    title: Text('Info',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(children: <Widget>[
                      Align(
                          child: Text(widget.airspace.name,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor)),
                          alignment: Alignment.centerLeft),
                      Align(
                          child: Text(widget.airspace.category),
                          alignment: Alignment.centerLeft),
                    ]))),
            Card(
                child: ListTile(
                    title: Text('Vertical limits',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(children: <Widget>[
                      Align(
                          child: Text(
                              '${widget.airspace.ceilingRef} ${widget.airspace.ceiling} ${widget.airspace.ceilingUnit}'),
                          alignment: Alignment.centerLeft),
                      Align(
                          child: Text(
                              '${widget.airspace.floorRef} ${widget.airspace.floor} ${widget.airspace.floorUnit}'),
                          alignment: Alignment.centerLeft),
                    ])))
          ])),
    );
  }
}
