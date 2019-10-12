import 'package:flutter/material.dart';

class LandingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FluttAir v0.1'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Home'),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
    );
  }
}