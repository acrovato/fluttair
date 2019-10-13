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
        defaultBrightness: Brightness.dark,
        data: (brightness) => ThemeData(
              brightness: brightness,
              dividerColor: Colors.black,
              accentColor: Colors.lightBlue,
              primaryColor: Colors.lightBlue,
              primaryColorDark: Colors.blue,
              hintColor: Colors.grey,
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
