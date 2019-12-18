import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'package:fluttair/utils/snackbar.dart';

import 'package:fluttair/database/flight.dart';
import 'package:fluttair/database/internet.dart';

import 'sidebar.dart';

/// Preference page
class SettingsView extends StatefulWidget {
  SettingsView({Key key}) : super(key: key);

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showDialog(dynamic provider, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Clear $type data?"),
          content: Text(
              "This will remove all the $type data from your device."),
          actions: <Widget>[
            FlatButton(
                child: Text("Clear"),
                onPressed: () {
                  Navigator.of(context).pop();
                  provider.clear();
                  _scaffoldKey.currentState.showSnackBar(snackBar(
                      '${type[0].toUpperCase()}${type.substring(1)} data cleared'));
                }),
            FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop())
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              RadioPreference('knots', 'kts', 'speed_unit',
                  selected: true, isDefault: true, onSelect: () {}),
              RadioPreference('km/h', 'kmh', 'speed_unit', onSelect: () {}),
              RadioPreference('mph', 'mph', 'speed_unit', onSelect: () {})
            ],
            title: 'Speed',
            cancelText: 'Cancel',
          ),
        ),
        PreferenceTitle('User data'),
        Builder(builder: (context) {
          return ListTile(
              title: Text('Clear flight data'),
              onTap: () async {
                FlightProvider provider = FlightProvider();
                _showDialog(provider, 'flight');
              });
        }),
        Builder(builder: (context) {
          return ListTile(
              title: Text('Clear weather data'),
              onTap: () async {
                WeatherProvider provider = WeatherProvider();
                _showDialog(provider, 'weather');
              });
        }),
        Builder(builder: (context) {
          return ListTile(
              title: Text('Clear NOTAM data'),
              onTap: () {
                NotamsProvider provider = NotamsProvider();
                _showDialog(provider, 'NOTAM');
              });
        }),
        PreferenceTitle('Appearance'),
        SwitchPreference('Dark theme', 'dark', defaultVal: false, onEnable: () {
          DynamicTheme.of(context).setBrightness(Brightness.dark);
        }, onDisable: () {
          DynamicTheme.of(context).setBrightness(Brightness.light);
        }),
        PreferenceTitle('About'),
        PreferencePageLink(
          'About fluttAir',
          page: PreferencePage([PreferenceText('This is fluttAir v0.1.')]),
        ),
        PreferencePageLink(
          'Report bug',
          trailing: Icon(Icons.mail_outline),
          page: PreferencePage([
            TextFieldPreference('', 'bug_report',
                maxLines: 10, defaultVal: 'Write your bug then click "submit"')
          ]),
        ),
      ]),
    );
  }
}
