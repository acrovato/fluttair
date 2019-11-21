import 'package:flutter/material.dart';

import 'package:fluttair/model/navaid.dart';

/// Navaid view
class NavaidView extends StatefulWidget {
  final Navaid navaid;

  NavaidView({Key key, @required this.navaid}) : super(key: key);

  @override
  NavaidViewState createState() => NavaidViewState();
}

class NavaidViewState extends State<NavaidView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            leading: BackButton(),
            title: Text(widget.navaid.callsign),
          ),
          body: ListView(children: <Widget>[
            Card(
                child: ListTile(
                    title:
                    Text('Info', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(children: <Widget>[
                      Align(
                          child: Text(widget.navaid.name,
                              style:
                              TextStyle(color: Theme.of(context).accentColor)),
                          alignment: Alignment.centerLeft),
                      Align(
                          child: Text(widget.navaid.callsign),
                          alignment: Alignment.centerLeft),
                      Align(
                          child: Text(widget.navaid.type),
                          alignment: Alignment.centerLeft)
                    ]))),
            Card(
                child: ListTile(
                    title: Text('Location',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(children: <Widget>[
                      Align(
                          child: Text('${widget.navaid.latitude}'),
                          alignment: Alignment.centerLeft),
                      Align(
                          child: Text('${widget.navaid.longitude}'),
                          alignment: Alignment.centerLeft),
                      Align(
                          child: Text(
                              '${widget.navaid.elevation} ${widget.navaid.elevationUnit}'),
                          alignment: Alignment.centerLeft)
                    ]))),
            Card(
                child: ListTile(
                    title:
                    Text('Frequency', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(children: <Widget>[
                      Align(
                          child: Text('${widget.navaid.frequency} / ${widget.navaid.channel}',
                              style:
                              TextStyle(color: Theme.of(context).accentColor)),
                          alignment: Alignment.centerLeft),
                      Align(
                          child: Text('${widget.navaid.range} ${widget.navaid.rangeUnit}'),
                          alignment: Alignment.centerLeft),
                    ]))),
          ])),
    );
  }
}
