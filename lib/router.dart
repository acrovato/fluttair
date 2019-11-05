import 'package:flutter/material.dart';

import 'package:fluttair/views/home.dart';
import 'package:fluttair/views/flights.dart';
import 'package:fluttair/views/countries.dart';
import 'package:fluttair/views/settings.dart';

Map<String, WidgetBuilder> myRoute = {
  '/': (context) => HomeView(),
  '/flights': (context) => FlightsView(),
  '/countries': (context) => CountriesView(),
  '/settings': (context) => SettingsView()
};
