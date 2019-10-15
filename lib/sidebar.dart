import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: DrawerHeader(
                child: Row(
                  children: <Widget>[
                    BackButton(),
                    Text('FluttAir v0.1',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero),
          ),
          ListTile(
            title: Text('Flights'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/flights', ModalRoute.withName('/')); // or (Route<dynamic> route) => false
            },
          ),
          ListTile(
            title: Text('Airports'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/airports', ModalRoute.withName('/'));
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/settings', ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }
}
