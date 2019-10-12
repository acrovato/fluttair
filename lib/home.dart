import 'package:flutter/material.dart';

import 'sidebar.dart';

class MyHome extends StatelessWidget {
  MyHome(this.icon, this.text);

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

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text('Home'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.flight_takeoff)),
              Tab(icon: Icon(Icons.language)),
              Tab(icon: Icon(Icons.flight_land)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyHome(Icons.flight_takeoff, 'Planned flights'),
            MyHome(Icons.language, 'Map'),
            MyHome(Icons.flight_land, 'Recorded flights'),
          ],
        ),
      ),
    );
  }
}
