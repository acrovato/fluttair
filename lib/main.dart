import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'router.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  runApp(Fluttair());
}

class Fluttair extends StatelessWidget {
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (Brightness brightness) => ThemeData(
              brightness: brightness,
              dividerColor: Colors.grey,
              accentColor: Colors.blueAccent,
              primaryColor: brightness == Brightness.light ? Colors.blueAccent : Color(4280361249),
              textSelectionHandleColor: Colors.blueAccent,
              toggleableActiveColor: Colors.blueAccent,
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
