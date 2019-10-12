import 'package:flutter/material.dart';

import 'router.dart';

void main() => runApp(Fluttair());

class Fluttair extends StatelessWidget {
  ThemeData lightTheme() {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      dividerColor: Colors.black,
      accentColor: Colors.lightBlue,
      primaryColor: Colors.lightBlue,
      primaryColorDark: Colors.blue,
      hintColor: Colors.grey,
      // Define the default font family.
      fontFamily: 'Montserrat',
      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FluttAir',
        theme: lightTheme(),
        darkTheme: Theme.of(context).copyWith(brightness: Brightness.dark),
        routes: myRoute,
    );
  }
}
