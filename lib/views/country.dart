import 'package:flutter/material.dart';

import 'package:fluttair/database/local.dart';
import 'package:fluttair/model/country.dart';
import 'package:fluttair/model/airport.dart';
import 'package:fluttair/model/airspace.dart';
import 'package:fluttair/model/navaid.dart';

import 'package:fluttair/utils/searchbar.dart';

import 'airport.dart';
import 'airspace.dart';
import 'navaid.dart';

/// Country view
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

/// Airport list tab
class _AirportsTab extends StatefulWidget {
  final Country country;

  _AirportsTab({Key key, @required this.country}) : super(key: key);

  @override
  _AirportsTabState createState() => _AirportsTabState();
}

class _AirportsTabState extends State<_AirportsTab> {
  static Future<List<Airport>> airports;
  TextEditingController searchController = TextEditingController();
  String filter;

  @override
  void initState() {
    airports = DatabaseProvider().getAirports(widget.country);
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget searchResults(BuildContext context, List data, int i, String filter) {
    if (filter == null || filter.isEmpty)
      return airportTile(context, data, i);
    else if (data[i]
            .icao
            .toString()
            .toLowerCase()
            .contains(filter.toLowerCase()) ||
        data[i].name.toString().toLowerCase().contains(filter.toLowerCase()))
      return airportTile(context, data, i);
    else
      return Container();
  }

  Widget airportTile(BuildContext context, List data, int i) {
    return ListTile(
        title: Text(data[i].icao,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor)),
        subtitle: Text(data[i].name),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AirportView(airport: data[i])));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SearchBar(controller: searchController, text: 'airports'),
      Expanded(
          child: FutureBuilder(
              future: airports,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return searchResults(context, snapshot.data, i, filter);
                      });
                } else if (snapshot.hasError) {
                  return Container(
                      child: Text(snapshot.error.toString(),
                          style: TextStyle(color: Colors.red)),
                      margin: EdgeInsets.all(10));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }))
    ]);
  }
}

/// Airspace list tab
class _AirspacesTab extends StatefulWidget {
  final Country country;

  _AirspacesTab({Key key, @required this.country}) : super(key: key);

  @override
  _AirspacesTabState createState() => _AirspacesTabState();
}

class _AirspacesTabState extends State<_AirspacesTab> {
  static Future<List<Airspace>> airspaces;
  TextEditingController searchController = TextEditingController();
  String filter;

  @override
  void initState() {
    airspaces = DatabaseProvider().getAirspaces(widget.country);
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget searchResults(BuildContext context, List data, int i, String filter) {
    if (filter == null || filter.isEmpty)
      return airspaceTile(context, data, i);
    else if (data[i]
        .name
        .toString()
        .toLowerCase()
        .contains(filter.toLowerCase()))
      return airspaceTile(context, data, i);
    else
      return Container();
  }

  Widget airspaceTile(BuildContext context, List data, int i) {
    return ListTile(
        title: Text(data[i].name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor)),
        subtitle: Text(data[i].category),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AirspaceView(airspace: data[i])));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SearchBar(controller: searchController, text: 'airspaces'),
      Expanded(
          child: FutureBuilder(
              future: airspaces,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return searchResults(context, snapshot.data, i, filter);
                      });
                } else if (snapshot.hasError) {
                  return Container(
                      child: Text(snapshot.error.toString(),
                          style: TextStyle(color: Colors.red)),
                      margin: EdgeInsets.all(10));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }))
    ]);
  }
}

/// Navaid list tab
class _NavaidsTab extends StatefulWidget {
  final Country country;

  _NavaidsTab({Key key, @required this.country}) : super(key: key);

  @override
  _NavaidsTabState createState() => _NavaidsTabState();
}

class _NavaidsTabState extends State<_NavaidsTab> {
  static Future<List<Navaid>> navaids;
  TextEditingController searchController = TextEditingController();
  String filter;

  @override
  void initState() {
    navaids = DatabaseProvider().getNavaids(widget.country);
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget searchResults(BuildContext context, List data, int i, String filter) {
    if (filter == null || filter.isEmpty)
      return navaidTile(context, data, i);
    else if (data[i]
            .callsign
            .toString()
            .toLowerCase()
            .contains(filter.toLowerCase()) ||
        data[i].name.toString().toLowerCase().contains(filter.toLowerCase()))
      return navaidTile(context, data, i);
    else
      return Container();
  }

  Widget navaidTile(BuildContext context, List data, int i) {
    return ListTile(
        title: Text(data[i].callsign,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor)),
        subtitle: Text(data[i].name),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NavaidView(navaid: data[i])));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SearchBar(controller: searchController, text: 'navaids'),
      Expanded(
          child: FutureBuilder(
              future: navaids,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return searchResults(context, snapshot.data, i, filter);
                      });
                } else if (snapshot.hasError) {
                  return Container(
                      child: Text(snapshot.error.toString(),
                          style: TextStyle(color: Colors.red)),
                      margin: EdgeInsets.all(10));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }))
    ]);
  }
}
