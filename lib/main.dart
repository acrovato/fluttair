import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'router.dart';

main() async {
  await PrefService.init(prefix: 'pref_');
  runApp(Fluttair());
}

class Fluttair extends StatelessWidget {
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              brightness: brightness,
              //dividerColor: Colors.black,
              //accentColor: Colors.blueAccent,
              //primaryColor: Colors.blue,
              //primaryColorDark: Colors.indigo,
              //hintColor: Colors.grey,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'FluttAir',
            theme: theme,
            routes: myRoute,
          );
        });
  }
}
