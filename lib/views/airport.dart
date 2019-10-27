import 'package:flutter/material.dart';
import 'package:fluttair/fake_database.dart';

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
            _DataCard(airport: widget.airport),
            _WxCard(),
            _NotamCard(),
          ],
        ),
      ),
    );
  }
}

class _DataCard extends StatefulWidget {
  final Airport airport;

  _DataCard({Key key, @required this.airport}) : super(key: key);

  @override
  _DataCardState createState() => _DataCardState();
}

class _DataCardState extends State<_DataCard> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          child: ListTile(
              title:
                  Text('Info', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Table(
                children: [
                  TableRow(children: [
                    Text(widget.airport.icao),
                    Text(widget.airport.iata),
                    Text(widget.airport.name)
                  ]),
                  TableRow(children: [
                    Text('${widget.airport.lat}N'),
                    Text('${widget.airport.lng}E'),
                    Text('${widget.airport.elv} ft')
                  ])
                ],
              )),
        ),
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
                    Text('${widget.airport.srsez}Z'),
                    Text('${widget.airport.srsel}L')
                  ]),
                  TableRow(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.brightness_5)),
                    Text('${widget.airport.ssetz}Z'),
                    Text('${widget.airport.ssetl}L')
                  ])
                ],
              )),
        ),
        Card(
          child: ListTile(
              title: Text('Runways',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.airport.rwysi.length,
                  itemBuilder: (context, i) {
                    return Row(children: <Widget>[
                      Expanded(child: Text(widget.airport.rwysi[i])),
                      Expanded(child: Text('${widget.airport.rwysd[i]} ft')),
                      Expanded(child: Text(widget.airport.rwyst[i]))
                    ]);
                  })),
        ),
        Card(
          child: ListTile(
              title: Text('Frequencies',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.airport.frqi.length,
                  itemBuilder: (context, i) {
                    return Row(children: <Widget>[
                      Expanded(child: Text(widget.airport.frqi[i])),
                      Expanded(child: Text(widget.airport.frqf[i])),
                      Expanded(child: Text(widget.airport.frqc[i]))
                    ]);
                  })),
        ),
        Card(
            child: ListTile(
          title: Text('Contact',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(widget.airport.ctc),
        )),
      ],
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

class _NotamCard extends StatefulWidget {
  @override
  _NotamCardState createState() => _NotamCardState();
}

class _NotamCardState extends State<_NotamCard> {
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
