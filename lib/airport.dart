import 'package:flutter/material.dart';

class AirportView extends StatefulWidget {
  final name;
  final icao;

  AirportView({Key key, @required this.name, @required this.icao})
      : super(key: key);

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
          title: Text(widget.icao),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Data'),
              Tab(text: 'Weather'),
              Tab(text: 'NOTAM'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DataCard(name: widget.name, icao: widget.icao),
            _WxCard(),
            _NotamCard(),
          ],
        ),
      ),
    );
  }
}

class _DataCard extends StatefulWidget {
  final name;
  final icao;

  _DataCard({Key key, @required this.name, @required this.icao})
      : super(key: key);

  @override
  _DataCardState createState() => _DataCardState();
}

class _DataCardState extends State<_DataCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
                child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text('ICAO',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text('IATA',
                            style: TextStyle(fontWeight: FontWeight.bold)))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text(widget.name)),
                    Expanded(child: Text(widget.icao)),
                    Expanded(child: Text('IATA'))
                  ],
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class _WxCard extends StatefulWidget {
  @override
  _WxCardState createState() => _WxCardState();
}

class _WxCardState extends State<_WxCard> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('METAR'),
          subtitle: Text(
              'ICAO 999999Z 00000KT 9999 -SHRA FEW040 SCT060 BKN080 OVC010 15/5 Q1013 TEMPO 7500 TSRA'),
          trailing: Text(
            'VFR',
            style: TextStyle(color: Colors.green),
          ),
        ),
        ListTile(
            title: Text('TAF'),
            subtitle: Text(
                'ICAO 999999Z 9999/9999 00000KT 9999 -SHRA FEW040 SCT060 TEMPO 9999/9999 99999G99KT 7500 TSRA PROB30 9999/9999 SN'))
      ],
    );
  }
}

class _NotamCard extends StatefulWidget {
  @override
  _NotamCardState createState() => _NotamCardState();
}

class _NotamCardState extends State<_NotamCard> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      ListTile(
          title: Text('A1234/06 NOTAMR A1212/06\n'
              'Q)ICAO/QMXLC/IV/NBO/A/000/999/5129N00028W005\n'
              'A)EGLL\n'
              'B)0609050500\n'
              'C)0704300500\n'
              'E)DUE WIP TWY B SOUTH CLSD BTN F AND R. TWY R CLSD BTN A AND B AND DIVERTED VIA NEW GREEN CL AND BLUE EDGE LGT. CTN ADZ'))
    ]);
  }
}
