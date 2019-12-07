import 'package:flutter/material.dart';

import 'sidebar.dart';

class MyFlightsCard extends StatelessWidget {
  MyFlightsCard(this.icon, this.text);

  final icon;
  final text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 128.0),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class FlightsView extends StatefulWidget {
  FlightsView({Key key}) : super(key: key);

  @override
  FlightsViewState createState() => FlightsViewState();
}

class FlightsViewState extends State<FlightsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text('Flights'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.flight_takeoff)),
              Tab(icon: Icon(Icons.flight_land)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyFlightsCard(Icons.flight_takeoff, 'Planned flights'),
            MyFlightsCard(Icons.flight_land, 'Recorded flights'),
          ],
        ),
      ),
    );
  }
}
