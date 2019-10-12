import 'package:flutter/material.dart';

import 'landing.dart';
import 'home.dart';
import 'settings.dart';

Map<String, WidgetBuilder> myRoute = {
  '/': (context) => LandingView(),
  '/home': (context) => HomeView(),
  '/settings': (context) => SettingsView()
};
