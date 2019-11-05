import 'package:flutter/material.dart';

import 'package:fluttair/model/database.dart';
import 'package:fluttair/model/airport.dart';
import 'package:fluttair/model/runway.dart';
import 'package:fluttair/model/frequency.dart';

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
            _WxTab(),
            _NotamTab(),
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
              title: Text('Timezone',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Table(
                children: [
                  TableRow(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_7)),
                    Text('0600Z'),
                    Text('0800L')
                  ]),
                  TableRow(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_5)),
                    Text('1600Z'),
                    Text('1800L')
                  ])
                ],
              )),
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
  @override
  _WxTabState createState() => _WxTabState();
}

class _WxTabState extends State<_WxTab> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: ListView(
        children: <Widget>[
          Card(
              child: ListTile(
            title: Text('METAR'),
            subtitle: Text(
                'ICAO 999999Z 00000KT 9999 -SHRA FEW040 SCT060 BKN080 OVC010 15/5 Q1013 TEMPO 7500 TSRA'),
            trailing: Text(
              'VFR',
              style: TextStyle(color: Colors.green),
            ),
          )),
          Card(
              child: ListTile(
                  title: Text('TAF'),
                  subtitle: Text(
                      'ICAO 999999Z 9999/9999 00000KT 9999 -SHRA FEW040 SCT060 TEMPO 9999/9999 99999G99KT 7500 TSRA PROB30 9999/9999 SN')))
        ],
      ),
      onRefresh: _refreshTmp,
    );
  }
}

class _NotamTab extends StatefulWidget {
  @override
  _NotamTabState createState() => _NotamTabState();
}

class _NotamTabState extends State<_NotamTab> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView(children: <Widget>[
          Card(
              child: ListTile(
                  title: Text('A1234/06 NOTAMR A1212/06\n'
                      'Q)ICAO/QMXLC/IV/NBO/A/000/999/5129N00028W005\n'
                      'A)EGLL\n'
                      'B)0609050500\n'
                      'C)0704300500\n'
                      'E)DUE WIP TWY B SOUTH CLSD BTN F AND R. TWY R CLSD BTN A AND B AND DIVERTED VIA NEW GREEN CL AND BLUE EDGE LGT. CTN ADZ')))
        ]),
        onRefresh: _refreshTmp);
  }
}

Future<Null> _refreshTmp() async {
  print('refreshing...');
}
