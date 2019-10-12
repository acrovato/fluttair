import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  Widget myDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: <Widget>[
                BackButton(),
                Text('Menu'),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }

  Widget myHome(icon, text) {
    return Card(
      color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: myDrawer(context),
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
              myHome(Icons.flight_takeoff, 'Planned flights'),
              myHome(Icons.language, 'Map'),
              myHome(Icons.flight_land, 'Recorded flights'),
            ],
          ),
        ),
      ),
    );
  }
}
