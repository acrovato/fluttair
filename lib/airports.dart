import 'package:flutter/material.dart';

import 'sidebar.dart';
import 'fake_database.dart';

class AirportsView extends StatefulWidget {
  @override
  AirportsViewState createState() => AirportsViewState();
}

class AirportsViewState extends State<AirportsView> {
  final database = Database();

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: Database().tempSize,
        itemBuilder: (context, i) {
          return _buildRow(i);
        });
  }

  Widget _buildRow(int i) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          database.airportsFav[i] ? Icons.favorite : Icons.favorite_border,
          color: database.airportsFav[i] ? Theme.of(context).accentColor : null,
        ),
        tooltip: 'Add or remove from favorite',
        onPressed: () {
          setState(() {
            database.airportsFav[i] ? database.airportsFav[i] = false : database.airportsFav[i] = true;
          });
        },
      ),
      title: Text(database.airportNames[i]),
      subtitle: Text(database.airportICAO[i]),
      trailing: IconButton(
        icon: Icon(
          database.airportsToDate[i] ? null : Icons.refresh,
          color: Theme.of(context).accentColor,
        ),
        tooltip: 'Update airport data',
        onPressed: () {
          setState(() {
            database.airportsToDate[i] = true;
          });
        },
      ),
      onTap: () {
        /*open airport*/
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //_airportsGenerator();
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text('Airports'),
      ),
      body: _buildList(),
    );
  }
}
