import 'package:flutter/material.dart';

import 'package:fluttair/database/flight.dart';
import 'package:fluttair/model/flight.dart';
import 'package:fluttair/views/flight.dart';

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
          children: [_PlannedTab(), _ArchivedTab()],
        ),
      ),
    );
  }
}

class _PlannedTab extends StatefulWidget {
  _PlannedTab({Key key}) : super(key: key);

  @override
  _PlannedTabState createState() => _PlannedTabState();
}

class _PlannedTabState extends State<_PlannedTab> {
  final FlightProvider _flightProvider = FlightProvider();

  @override
  void initState() {
    super.initState();
  }

  Widget flightTile(BuildContext context, Flight flight) {
    List<PopupMenuItem<int>> _actions = List(2);
    _actions[0] = PopupMenuItem<int>(child: Text('Archive'), value: 0);
    _actions[1] = PopupMenuItem<int>(child: Text('Delete'), value: 1);

    void _choiceAction(int choice) {
      if (choice == 0) {
        flight.archived = true;
        _flightProvider.saveFlight(flight);
      } else if (choice == 1) _flightProvider.deleteFlight(flight.id);
      setState(() {});
    }

    if (flight.archived)
      return Container();
    else {
      return Card(
          child: ListTile(
              title: Row(children: <Widget>[
                Text(flight.departure,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor)),
                Icon(Icons.arrow_right),
                Text(flight.arrival,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor))
              ]),
              subtitle: Text(flight.name),
              trailing: PopupMenuButton<int>(
                  onSelected: _choiceAction,
                  itemBuilder: (BuildContext context) => _actions),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlightPlanView(flight: flight)));
              }));
    }
  }

  Widget _flightList(AsyncSnapshot<List> snapshot) {
    if (snapshot.hasData) {
      int count = 0;
      for (var flt in snapshot.data) if (flt.archived) count++;
      if (snapshot.data.length != 0 && count != snapshot.data.length) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              return flightTile(context, snapshot.data[i]);
            });
      } else
        return Center(child: Text('No flight planned'));
    } else if (snapshot.hasError) {
      return Container(
          child: Text(snapshot.error.toString()), margin: EdgeInsets.all(10));
    } else
      return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _flightProvider.getFlights(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          return Stack(children: <Widget>[
            _flightList(snapshot),
            Padding(
                padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          _flightProvider.createFlight();
                          setState(() {});
                        })))
          ]);
        });
  }
}

class _ArchivedTab extends StatefulWidget {
  _ArchivedTab({Key key}) : super(key: key);

  @override
  _ArchivedTabState createState() => _ArchivedTabState();
}

class _ArchivedTabState extends State<_ArchivedTab> {
  final FlightProvider _flightProvider = FlightProvider();

  @override
  void initState() {
    super.initState();
  }

  Widget flightTile(BuildContext context, Flight flight) {
    List<PopupMenuItem<int>> _actions = List(3);
    _actions[0] = PopupMenuItem<int>(child: Text('Export'), value: 0);
    _actions[1] = PopupMenuItem<int>(child: Text('Plan'), value: 1);
    _actions[2] = PopupMenuItem<int>(child: Text('Delete'), value: 2);

    void _choiceAction(int choice) {
      if (choice == 0)
        print('Export');
      else if (choice == 1) {
        flight.archived = false;
        _flightProvider.saveFlight(flight);
      } else if (choice == 2) _flightProvider.deleteFlight(flight.id);
      setState(() {});
    }

    if (flight.archived) {
      return Card(
          child: ListTile(
              title: Row(children: <Widget>[
                Text(flight.departure,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor)),
                Icon(Icons.arrow_right),
                Text(flight.arrival,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor))
              ]),
              subtitle: Text(flight.name),
              trailing: PopupMenuButton<int>(
                  onSelected: _choiceAction,
                  itemBuilder: (BuildContext context) => _actions),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FlightArchiveView(flight: flight)));
              }));
    } else
      return Container();
  }

  Widget _flightList(AsyncSnapshot<List> snapshot) {
    if (snapshot.hasData) {
      int count = 0;
      for (var flt in snapshot.data) if (!flt.archived) count++;
      if (snapshot.data.length != 0 && count != snapshot.data.length) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              return flightTile(context, snapshot.data[i]);
            });
      } else
        return Center(child: Text('No flight archived'));
    } else if (snapshot.hasError) {
      return Container(
          child: Text(snapshot.error.toString()), margin: EdgeInsets.all(10));
    } else
      return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _flightProvider.getFlights(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          return _flightList(snapshot);
        });
  }
}
