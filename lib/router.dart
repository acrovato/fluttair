import 'package:flutter/material.dart';

import 'package:fluttair/views/home.dart';
import 'package:fluttair/views/flights.dart';
import 'package:fluttair/views/airports.dart';
import 'package:fluttair/views/settings.dart';

Map<String, WidgetBuilder> myRoute = {
  '/': (context) => HomeView(),
  '/flights': (context) => FlightsView(),
  '/airports': (context) => AirportsView(),
  '/settings': (context) => SettingsView()
};
