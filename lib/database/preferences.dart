import 'package:shared_preferences/shared_preferences.dart';

/// Preferences helper database
class Preferences {
  static SharedPreferences _prefs;
  static final String _darkMode = 'dark_mode'; // set theme to dark
  static final String _defaultMap =
      'default_map'; // default map displayed in Map view
  static final String _gpsRefreshRate = 'gps_refresh'; // gps refresh rate
  static final String _speedUnit =
      'map_units_speed'; // units for speed in Map view
  static final String _altitudeUnit =
      'map_units_altitude'; // units for altitude in Map view
  static final String _speedFactor =
      'speed_factor'; // speed conversion factor from m/s
  static final String _altitudeFactor =
      'altitude_factor'; // altitude conversion factor from m

  static Future<SharedPreferences> init() async {
    return await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> get prefs async {
    if (_prefs == null) _prefs = await init();
    return _prefs;
  }

  static bool getDarkMode() {
    return _prefs.getBool(_darkMode) ?? false;
  }

  static void setDarkMode(bool value) {
    _prefs.setBool(_darkMode, value);
  }

  static int getDefaultMap() {
    return _prefs.getInt(_defaultMap) ?? 0;
  }

  static void setDefaultMap(int value) {
    _prefs.setInt(_defaultMap, value);
  }

  static int getGpsRefreshRate() {
    return _prefs.getInt(_gpsRefreshRate) ?? 5;
  }

  static void setGpsRefreshRate(int value) {
    _prefs.setInt(_gpsRefreshRate, value);
  }

  static String getSpeedUnit() {
    return _prefs.getString(_speedUnit) ?? 'kts';
  }

  static void setSpeedUnit(String value) {
    _prefs.setString(_speedUnit, value);
    _setSpeedFactor(value);
  }

  static String getAltitudeUnit() {
    return _prefs.getString(_altitudeUnit) ?? 'ft';
  }

  static void setAltitudeUnit(String value) {
    _prefs.setString(_altitudeUnit, value);
    _setAltitudeFactor(value);
  }

  static double getSpeedFactor() {
    return _prefs.getDouble(_speedFactor) ?? 1.944;
  }

  static void _setSpeedFactor(String unit) {
    if (unit == 'kts')
      _prefs.setDouble(_speedFactor, 1.944);
    else if (unit == 'km/h')
      _prefs.setDouble(_speedFactor, 3.6);
    else {
      setSpeedUnit('kts');
      throw Exception('Speed unit: $unit not known!\n');
    }
  }

  static double getAltitudeFactor() {
    return _prefs.getDouble(_altitudeFactor) ?? 3.281;
  }

  static void _setAltitudeFactor(String unit) {
    if (unit == 'ft')
      _prefs.setDouble(_altitudeFactor, 3.281);
    else if (unit == 'm')
      _prefs.setDouble(_altitudeFactor, 1.0);
    else {
      setAltitudeUnit('ft');
      throw Exception('Altitude unit: $unit not known!\n');
    }
  }
}
