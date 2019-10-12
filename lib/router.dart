import 'package:flutter/material.dart';

import 'landing.dart';
import 'home.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => LandingView());
    case '/home':
      return MaterialPageRoute(builder: (context) => HomeView());
    default:
      return MaterialPageRoute(builder: (context) => LandingView());
  }
}
