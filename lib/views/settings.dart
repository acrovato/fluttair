import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'package:fluttair/utils/snackbar.dart';
import 'package:fluttair/utils/dialog.dart';
import 'package:fluttair/utils/radio_dialog.dart';
import 'package:fluttair/utils/dropdown_list.dart';
import 'package:fluttair/utils/switch.dart';

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

  // TODO group into model or db
  // Fixed list of options
  final MapEntry<String, List<int>> _gpsRefreshRate =
      MapEntry('gps_refresh', [1, 5, 10, 20, 30, 60]);
  final MapEntry<String, List<String>> _unitsSpeed =
      MapEntry('map_units_speed', ['kts', 'km/h']);
  final MapEntry<String, List<String>> _unitsAlt =
      MapEntry('map_units_altitude', ['ft', 'm']);

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
        body: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView(children: <Widget>[
                  _title('General'),
                  _tile(
                      'Dark mode',
                      MySwitch(
                        setter: (val) =>
                            snapshot.data.setBool('dark_mode', val),
                        getter: () => snapshot.data.getBool('dark_mode'),
                        onEnable: () => DynamicTheme.of(context)
                            .setBrightness(Brightness.dark),
                        onDisable: () => DynamicTheme.of(context)
                            .setBrightness(Brightness.light),
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
                                initial: snapshot.data.getInt('default_map'),
                                data: MapProvider().getMaps(),
                                onChoiceChanged: (value) =>
                                    snapshot.data.setInt('default_map', value),
                              ))),
                  _tile(
                      'Position refresh rate (second)',
                      DropdownList(
                          initial: _gpsRefreshRate.value.indexOf(
                              snapshot.data.getInt(_gpsRefreshRate.key)),
                          data: _getFuture(_gpsRefreshRate.value),
                          onChanged: (val) => snapshot.data.setInt(
                              _gpsRefreshRate.key, _gpsRefreshRate.value[val])),
                      null),
                  _tile(
                    'Speed unit',
                    DropdownList(
                        initial: _unitsSpeed.value
                            .indexOf(snapshot.data.getString(_unitsSpeed.key)),
                        data: _getFuture(_unitsSpeed.value),
                        onChanged: (val) => snapshot.data.setString(
                            _unitsSpeed.key, _unitsSpeed.value[val])),
                    null,
                  ),
                  _tile(
                    'Altitude unit',
                    DropdownList(
                        initial: _unitsAlt.value
                            .indexOf(snapshot.data.getString(_unitsAlt.key)),
                        data: _getFuture(_unitsAlt.value),
                        onChanged: (val) => snapshot.data
                            .setString(_unitsAlt.key, _unitsAlt.value[val])),
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
                              text: "I am Fluttair!",
                              closeText: 'Close')))
                ]);
              } else if (snapshot.hasError) {
                return Container(
                    child: Text(snapshot.error.toString()),
                    margin: EdgeInsets.all(10));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
