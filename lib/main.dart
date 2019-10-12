import 'package:flutter/material.dart';

import 'router.dart' as router;

void main() => runApp(Fluttair());

class Fluttair extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluttAir',
      onGenerateRoute: router.generateRoute
    );
  }
}
