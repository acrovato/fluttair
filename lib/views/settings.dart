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
        PreferenceText('Soon come'),
        PreferenceTitle('Units'),
        PreferenceDialogLink(
          'Speed',
          dialog: PreferenceDialog(
            [
              RadioPreference('knots', 'kts', 'speed_unit', selected: true, isDefault: true, onSelect: () {}),
              RadioPreference('km/h', 'kmh', 'speed_unit', onSelect: () {}),
              RadioPreference('mph', 'mph', 'speed_unit', onSelect: () {})
            ],
            title: 'Speed',
            cancelText: 'Cancel',
          ),
        ),
        PreferenceTitle('Database'),
        PreferenceText('Soon come'),
        PreferenceTitle('Appearance'),
        SwitchPreference('Dark theme', 'dark', defaultVal: false, onEnable: () {
          DynamicTheme.of(context).setBrightness(Brightness.dark);
        }, onDisable: () {
          DynamicTheme.of(context).setBrightness(Brightness.light);
        }),
        PreferenceTitle('About'),
        PreferencePageLink(
          'About fluttAir',
          page: PreferencePage([
            PreferenceText('This is fluttAir v0.1.')
          ]),
        ),
        PreferencePageLink(
          'Report bug',
          trailing: Icon(Icons.mail_outline),
          page: PreferencePage([
            TextFieldPreference('', 'bug_report', maxLines: 10, defaultVal: 'Write your bug then click "submit"')
          ]),
        ),
      ]),
    );
  }
}
