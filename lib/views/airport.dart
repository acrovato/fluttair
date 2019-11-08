import 'package:fluttair/custom_icons.dart';
import 'package:flutter/material.dart';

import 'package:fluttair/custom_icons.dart' show CustomIcons;

import 'package:fluttair/model/database.dart';
import 'package:fluttair/model/airport.dart';
import 'package:fluttair/model/runway.dart';
import 'package:fluttair/model/frequency.dart';
import 'package:fluttair/model/weather.dart';
import 'package:fluttair/model/notam.dart';

class AirportView extends StatefulWidget {
  final Airport airport;

  AirportView({Key key, @required this.airport}) : super(key: key);

  @override
  AirportViewState createState() => AirportViewState();
}

class AirportViewState extends State<AirportView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text(widget.airport.icao),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Airport'),
              Tab(text: 'Weather'),
              Tab(text: 'NOTAM'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DataTab(airport: widget.airport),
            _WxTab(airport: widget.airport),
            _NotamTab(airport: widget.airport),
          ],
        ),
      ),
    );
  }
}

class _DataTab extends StatefulWidget {
  final Airport airport;

  _DataTab({Key key, @required this.airport}) : super(key: key);

  @override
  _DataTabState createState() => _DataTabState();
}

class _DataTabState extends State<_DataTab> {
  final dbProvider = DatabaseProvider();
  static Future<List<Runway>> runways;
  static Future<List<Frequency>> frequencies;

  @override
  void initState() {
    runways = dbProvider.getRunways(widget.airport);
    frequencies = dbProvider.getFrequencies(widget.airport);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
            child: ListTile(
                title:
                    Text('Info', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(children: <Widget>[
                  Align(
                      child: Text(widget.airport.name,
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      alignment: Alignment.centerLeft),
                  Align(
                      child: Text(widget.airport.icao),
                      alignment: Alignment.centerLeft),
                  Align(
                      child: Text(widget.airport.country),
                      alignment: Alignment.centerLeft),
                  Align(
                      child: Text(widget.airport.type),
                      alignment: Alignment.centerLeft)
                ]))),
        Card(
            child: ListTile(
                title: Text('Location',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(children: <Widget>[
                  Align(
                      child: Text('${widget.airport.latitude}'),
                      alignment: Alignment.centerLeft),
                  Align(
                      child: Text('${widget.airport.longitude}'),
                      alignment: Alignment.centerLeft),
                  Align(
                      child: Text(
                          '${widget.airport.elevation} ${widget.airport.elevationUnit}'),
                      alignment: Alignment.centerLeft)
                ]))),
        Card(
          child: ListTile(
            title:
                Text('Timezone', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(CustomIcons.sunrise, size: 32),
                    Expanded(
                        child: Text(
                            '${widget.airport.sunriseZ} - ${widget.airport.sunriseL}'))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(CustomIcons.sunset, size: 32),
                    Expanded(
                        child: Text(
                            '${widget.airport.sunsetZ} - ${widget.airport.sunsetL}'))
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
            child: ListTile(
                title: Text('Runways',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: FutureBuilder(
                    future: runways,
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (!snapshot.hasData)
                        return Container();
                      else {
                        return new ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              return Column(children: <Widget>[
                                Align(
                                  child: Text(snapshot.data[i].name,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).accentColor)),
                                  alignment: Alignment.centerLeft,
                                ),
                                Align(
                                  child: Text(
                                      '${snapshot.data[i].length} ${snapshot.data[i].lengthUnit} X ${snapshot.data[i].width} ${snapshot.data[i].widthUnit} (${snapshot.data[i].surface})'),
                                  alignment: Alignment.centerLeft,
                                )
                              ]);
                            });
                      }
                    }))),
        Card(
          child: ListTile(
              title: Text('Frequencies',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: FutureBuilder(
                  future: frequencies,
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (!snapshot.hasData)
                      return Container();
                    else {
                      return new ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            return Column(children: <Widget>[
                              Align(
                                child: Text(
                                    '<${snapshot.data[i].frequency}> ${snapshot.data[i].callsign}',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor)),
                                alignment: Alignment.centerLeft,
                              ),
                              Align(
                                child: Text(
                                    '${snapshot.data[i].category} (${snapshot.data[i].type})'),
                                alignment: Alignment.centerLeft,
                              )
                            ]);
                          });
                    }
                  })),
        )
      ],
    );
  }
}

class _WxTab extends StatefulWidget {
  final Airport airport;

  _WxTab({Key key, @required this.airport}) : super(key: key);

  @override
  _WxTabState createState() => _WxTabState();
}

class _WxTabState extends State<_WxTab> {
  Future<Weather> weather;

  @override
  void initState() {
    weather = fetchWeather(widget.airport.icao);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: FutureBuilder(
            future: weather,
            builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: <Widget>[
                    Card(
                        child: ListTile(
                      title: Text('METAR',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(snapshot.data.metar),
                      trailing: Text(
                        snapshot.data.flightRules,
                        style: TextStyle(
                            color: snapshot.data.color,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                    Container(
                        child: Text(snapshot.data.mtFetchTime,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor)),
                        margin: EdgeInsets.only(
                            left: 10.0, top: 2.0, bottom: 10.0, right: 0.0)),
                    Card(
                        child: ListTile(
                            title: Text('TAF',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(snapshot.data.taf))),
                    Container(
                        child: Text(snapshot.data.tfFetchTime,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor)),
                        margin: EdgeInsets.only(
                            left: 10.0, top: 2.0, bottom: 10.0, right: 0.0)),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            }),
        onRefresh: () async {
          setState(() {
            weather = fetchWeather(widget.airport.icao);
          });
          return null;
        });
  }
}

class _NotamTab extends StatefulWidget {
  final Airport airport;

  _NotamTab({Key key, @required this.airport}) : super(key: key);

  @override
  _NotamTabState createState() => _NotamTabState();
}

class _NotamTabState extends State<_NotamTab> {
  Future<Notam> notam;

  @override
  void initState() {
    notam = fetchNotam(widget.airport.icao);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: FutureBuilder(
            future: notam,
            builder: (BuildContext context, AsyncSnapshot<Notam> snapshot) {
              if (snapshot.hasData) {
                return Column(children: <Widget>[
                  Align(
                      child: Container(
                          child: Text(snapshot.data.fetchTime,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor)),
                          margin: EdgeInsets.only(
                              left: 10.0, top: 5.0, bottom: 10.0, right: 0.0)),
                      alignment: Alignment.centerLeft),
                  Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.notams.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Card(
                                child: Container(
                                    child: Text(snapshot.data.notams[i]),
                                    margin: EdgeInsets.all(10)));
                          }))
                ]);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            }),
        onRefresh: () async {
          setState(() {
            notam = fetchNotam(widget.airport.icao);
          });
          return null;
        });
  }
}
