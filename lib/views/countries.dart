import 'package:flutter/material.dart';

import 'package:fluttair/model/database.dart';

import 'sidebar.dart';
import 'country.dart';

class CountriesView extends StatefulWidget {
  @override
  CountriesViewState createState() => CountriesViewState();
}

class CountriesViewState extends State<CountriesView> {
  TextEditingController editingController = TextEditingController();
  final dbProvider = DatabaseProvider();

  Widget _buildList() {
    return FutureBuilder(
        future: dbProvider.getCountries(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (!snapshot.hasData)
            return Container();
          else {
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return ListTile(
                      title: Text(snapshot.data[i].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor)),
                      subtitle: Text(snapshot.data[i].code),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CountryView(country: snapshot.data[i])));
                      });
                });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text('Countries'),
        ),
        body: _buildList());
  }
}
