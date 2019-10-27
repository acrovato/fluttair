import 'package:flutter/material.dart';

import 'sidebar.dart';
import 'airport.dart';
import 'package:fluttair/fake_database.dart';

class AirportsView extends StatefulWidget {
  @override
  AirportsViewState createState() => AirportsViewState();
}

class AirportsViewState extends State<AirportsView> {
  TextEditingController editingController = TextEditingController();
  final database = Database();

  Widget _buildLists() {
    return Scrollbar(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: database.aptcati.length,
            itemBuilder: (context, i) {
              return _buildList(i);
            }));
  }

  Widget _buildList(int i) {
    return ListTile(
        title: Text(database.aptcati[i],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor)),
        subtitle: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: database.aptcats[database.aptcati[i]].length,
            itemBuilder: (context, j) {
              return _buildRow(i, j);
            }));
  }

  Widget _buildRow(int i, int j) {
    return ListTile(
      leading: IconButton(
        alignment: Alignment.centerLeft,
        icon: Icon(
          database.isFav[database.aptcats[database.aptcati[i]][j]]
              ? Icons.favorite
              : Icons.favorite_border,
          color: database.isFav[database.aptcats[database.aptcati[i]][j]]
              ? Theme.of(context).accentColor
              : null,
        ),
        tooltip: 'Add or remove from favorite',
        onPressed: () {
          setState(() {
            if (database.isFav[database.aptcats[database.aptcati[i]][j]]) {
              database.isFav[database.aptcats[database.aptcati[i]][j]] = false;
              database.aptcats['Favorites']
                  .remove(database.aptcats[database.aptcati[i]][j]);
            } else {
              database.isFav[database.aptcats[database.aptcati[i]][j]] = true;
              database.aptcats['Favorites']
                  .add(database.aptcats[database.aptcati[i]][j]);
            }
          });
        },
      ),
      title: Text(
          database.airports[database.aptcats[database.aptcati[i]][j]].icao),
      subtitle: Text(
          database.airports[database.aptcats[database.aptcati[i]][j]].name),
      trailing: IconButton(
        alignment: Alignment.centerRight,
        icon: Icon(
            database.isDate[database.aptcats[database.aptcati[i]][j]]
                ? Icons.check
                : Icons.refresh,
            color: database.isDate[database.aptcats[database.aptcati[i]][j]]
                ? Colors.green
                : Theme.of(context).accentColor),
        tooltip: 'Update airport data',
        onPressed: () {
          setState(() {
            database.isDate[database.aptcats[database.aptcati[i]][j]] = true;
          });
        },
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AirportView(
                    airport: database
                        .airports[database.aptcats[database.aptcati[i]][j]])));
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
      body: Column(
        children: <Widget>[
          // TODO https://blog.usejournal.com/flutter-search-in-listview-1ffa40956685
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {},
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(child: _buildLists())
        ],
      ),
    );
    //);
  }
}
