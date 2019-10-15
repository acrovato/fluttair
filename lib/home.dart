import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FluttAir v0.1'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Flights'),
          onPressed: () {
            Navigator.pushNamed(context, '/flights');
          },
        ),
      ),
    );
  }
}