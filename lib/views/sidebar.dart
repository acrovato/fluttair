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
            height: MediaQuery.of(context).size.height * 0.12,
            child: DrawerHeader(
                child: Row(
                  children: <Widget>[
                    BackButton(),
                    Text('FluttAir',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero),
          ),
          //Divider(thickness: 1.5),
          ListTile(
            title: Text('Flights'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/flights');
            },
          ),
          ListTile(
            title: Text('Airports'),
            onTap: () {
              Navigator.pop(context);
              ModalRoute.of(context).isFirst ? Navigator.pushNamed(context, '/airports') : Navigator.pushReplacementNamed(context, '/airports');
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              ModalRoute.of(context).isFirst ? Navigator.pushNamed(context, '/settings') : Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          Divider(),
          ListTile(
            title: Text('v0.1')
          ),
        ],
      ),
    );
  }
}
