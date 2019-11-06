import 'package:flutter/material.dart';

import 'package:fluttair/model/database.dart';
import 'package:fluttair/model/country.dart';
import 'package:fluttair/model/airport.dart';
import 'package:fluttair/model/airspace.dart';
import 'package:fluttair/model/navaid.dart';

import 'airport.dart';
import 'airspace.dart';
import 'navaid.dart';

class CountryView extends StatefulWidget {
  final Country country;

  CountryView({Key key, @required this.country}) : super(key: key);

  @override
  CountryViewState createState() => CountryViewState();
}

class CountryViewState extends State<CountryView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text(widget.country.name),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Airports'),
              Tab(text: 'Airspaces'),
              Tab(text: 'Navaids'),
            ],
          ),
        ),
        // TODO: implement a searchbar for each tab?
        body: TabBarView(
          children: [
            _AirportsTab(country: widget.country),
            _AirspacesTab(country: widget.country),
            _NavaidsTab(country: widget.country),
          ],
        ),
      ),
    );
  }
}

class _AirportsTab extends StatefulWidget {
  final Country country;

  _AirportsTab({Key key, @required this.country}) : super(key: key);

  @override
  _AirportsTabState createState() => _AirportsTabState();
}

class _AirportsTabState extends State<_AirportsTab> {
  static Future<List<Airport>> airports;

  // TODO: consider using a List instead of Future<List> (https://grokonez.com/flutter/flutter-sqlite-example-listview-crud-operations-sqflite-plugin)
  @override
  void initState() {
    airports = DatabaseProvider().getAirports(widget.country);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: airports,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (!snapshot.hasData)
            return Container();
          else {
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return ListTile(
                      title: Text(snapshot.data[i].icao,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor)),
                      subtitle: Text(snapshot.data[i].name),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AirportView(airport: snapshot.data[i])));
                      });
                });
          }
        });
  }
}

class _AirspacesTab extends StatefulWidget {
  final Country country;

  _AirspacesTab({Key key, @required this.country}) : super(key: key);

  @override
  _AirspacesTabState createState() => _AirspacesTabState();
}

class _AirspacesTabState extends State<_AirspacesTab> {
  static Future<List<Airspace>> airspaces;

  @override
  void initState() {
    airspaces = DatabaseProvider().getAirspaces(widget.country);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: airspaces,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (!snapshot.hasData)
            return Container();
          else {
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return ListTile(
                      title: Text(snapshot.data[i].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor)),
                      subtitle: Text(snapshot.data[i].category),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AirspaceView(airspace: snapshot.data[i])));
                      });
                });
          }
        });
  }
}

class _NavaidsTab extends StatefulWidget {
  final Country country;

  _NavaidsTab({Key key, @required this.country}) : super(key: key);

  @override
  _NavaidsTabState createState() => _NavaidsTabState();
}

class _NavaidsTabState extends State<_NavaidsTab> {
  static Future<List<Navaid>> navaids;

  @override
  void initState() {
    navaids = DatabaseProvider().getNavaids(widget.country);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: navaids,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (!snapshot.hasData)
            return Container();
          else {
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return ListTile(
                      title: Text(snapshot.data[i].callsign,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor)),
                      subtitle: Text(snapshot.data[i].name),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NavaidView(navaid: snapshot.data[i])));
                      });
                });
          }
        });
  }
}
