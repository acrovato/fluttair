import 'package:flutter/material.dart';

import 'home.dart';
import 'flights.dart';
import 'airports.dart';
import 'settings.dart';

Map<String, WidgetBuilder> myRoute = {
  '/': (context) => HomeView(),
  '/flights': (context) => FlightsView(),
  '/airports': (context) => AirportsView(),
  '/settings': (context) => SettingsView()
};
