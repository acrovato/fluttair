import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'sidebar.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key key}) : super(key: key);

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: PreferencePage([
        PreferenceTitle('General'),
        PreferenceTitle('Units'),
        PreferenceDialogLink(
          'Speed',
          dialog: PreferenceDialog(
            [
              RadioPreference('knots', 'a', 'a', selected: true, isDefault: true),
              RadioPreference('km/h', 'b', 'b', onSelect: () {},),
              RadioPreference('mph', 'c', 'c')
            ],
            title: 'Speed',
            cancelText: 'Cancel',
          ),
        ),
        PreferenceTitle('Database'),
        PreferenceTitle('Appearance'),
        SwitchPreference('Dark theme', 'dark', defaultVal: false, onEnable: () {
          DynamicTheme.of(context).setBrightness(Brightness.dark);
        }, onDisable: () {
          DynamicTheme.of(context).setBrightness(Brightness.light);
        }),
        PreferenceTitle('About')
      ]),
    );
  }
}
