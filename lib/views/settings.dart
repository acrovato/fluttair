import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'package:fluttair/utils/snackbar.dart';
import 'package:fluttair/utils/dialog.dart';
import 'package:fluttair/utils/radio_dialog.dart';
import 'package:fluttair/utils/dropdown_list.dart';
import 'package:fluttair/utils/switch.dart';

import 'package:fluttair/database/preferences.dart';
import 'package:fluttair/database/map.dart';
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

  // Fixed list of options
  //static List<String> _altitudeLimit = _altitudes();
  final List<String> _altitudeLimit = [for (int i = 10; i <= 95; i += 5) '0${i}', '100'];
  final List<int> _gpsRefreshRate = [1, 5, 10, 20, 30, 60];
  final List<String> _unitsSpeed = ['kts', 'km/h'];
  final List<String> _unitsAlt = ['ft', 'm'];

  void _showDialog(dynamic provider, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
            title: "Clear $type data?",
            text: "This will remove all the $type data from your device.",
            closeText: 'Cancel',
            actionText: 'Clear',
            action: () {
              provider.clear();
              _scaffoldKey.currentState.showSnackBar(snackBar(
                  '${type[0].toUpperCase()}${type.substring(1)} data cleared'));
            });
      },
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, bottom: 0.0, top: 20.0),
      child: Text(
        text,
        style: TextStyle(
            color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _tile(String title, Widget button, void Function() onTap) {
    return ListTile(title: Text(title), trailing: button, onTap: onTap);
  }

  Future<List<dynamic>> _getFuture(List<dynamic> data) {
    Completer c = Completer<List<dynamic>>();
    c.complete(data);
    return c.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: SideBar(),
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(children: <Widget>[
          _title('General'),
          _tile(
              'Dark mode',
              MySwitch(
                setter: (value) => Preferences.setDarkMode(value),
                getter: () => Preferences.getDarkMode(),
                onEnable: () =>
                    DynamicTheme.of(context).setBrightness(Brightness.dark),
                onDisable: () =>
                    DynamicTheme.of(context).setBrightness(Brightness.light),
              ),
              null),
          _title('Map'),
          _tile(
              'Default map',
              null,
              () => showDialog(
                  context: context,
                  builder: (BuildContext context) => RadioDialog(
                        title: 'Set default map',
                        initial: Preferences.getDefaultMap(),
                        data: MapProvider().getMaps(),
                        onChoiceChanged: (value) =>
                            Preferences.setDefaultMap(value),
                      ))),
          _tile(
              'Display airspace layers below FL',
              DropdownList(
                  initial:
                  _altitudeLimit.indexOf(Preferences.getAltitudeLimit()),
                  data: _getFuture(_altitudeLimit),
                  onChanged: (value) =>
                      Preferences.setAltitudeLimit(_altitudeLimit[value])),
              null),
          _tile(
              'Position refresh rate (second)',
              DropdownList(
                  initial:
                      _gpsRefreshRate.indexOf(Preferences.getGpsRefreshRate()),
                  data: _getFuture(_gpsRefreshRate),
                  onChanged: (value) =>
                      Preferences.setGpsRefreshRate(_gpsRefreshRate[value])),
              null),
          _tile(
            'Speed unit',
            DropdownList(
                initial: _unitsSpeed.indexOf(Preferences.getSpeedUnit()),
                data: _getFuture(_unitsSpeed),
                onChanged: (value) =>
                    Preferences.setSpeedUnit(_unitsSpeed[value])),
            null,
          ),
          _tile(
            'Altitude unit',
            DropdownList(
                initial: _unitsAlt.indexOf(Preferences.getAltitudeUnit()),
                data: _getFuture(_unitsAlt),
                onChanged: (value) =>
                    Preferences.setAltitudeUnit(_unitsAlt[value])),
            null,
          ),
          _title('User data'),
          _tile('Clear flight data', null, () async {
            _showDialog(FlightProvider(), 'flight');
          }),
          _tile('Clear weather data', null, () async {
            _showDialog(WeatherProvider(), 'weather');
          }),
          _tile('Clear NOTAM data', null, () async {
            _showDialog(NotamsProvider(), 'NOTAM');
          }),
          _title('About'),
          _tile(
              'Fluttair',
              null,
              () => showDialog(
                  context: context,
                  builder: (BuildContext context) => MyDialog(
                      title: "About Fluttair",
                      text:
                          "Fluttair is a free and basic VFR navigation app developed by Adrien Crovato\nhttps://github.com/acrovato",
                      closeText: 'Close')))
        ]));
  }
}
