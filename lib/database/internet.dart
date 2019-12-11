import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import 'package:fluttair/model/weather.dart';
import 'package:fluttair/model/notam.dart';

// TODO abstract class, as separate commit

/// Weather database (from NOOA)
class WeatherProvider {
  static WeatherProvider _weatherProvider;
  static File _weatherFile;

  WeatherProvider._(); // named constructor

  factory WeatherProvider() {
    if (_weatherProvider == null) {
      _weatherProvider =
          WeatherProvider._(); // This is executed only once, singleton object
    }
    return _weatherProvider;
  }

  Future<File> get weatherFile async {
    if (_weatherFile == null) _weatherFile = await init();
    return _weatherFile;
  }

  init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File(join(directory.path, 'data', 'weather.json'));
    // If the file does not exist, create it
    if (!await file.exists()) {
      try {
        await Directory(dirname(file.path)).create(recursive: true);
      } catch (_) {}
      file.writeAsStringSync('{}');
    }
    return file;
  }

  Future<Weather> get(String icao) async {
    // Read the file
    Map<String, dynamic> wx = json.decode(_weatherFile.readAsStringSync());
    if (wx.containsKey(icao))
      return Weather.fromMap(wx[icao]);
    else
      return Weather();
  }

  void clear() {
    // Clear data
    _weatherFile.writeAsStringSync('{}');
  }

  Future<bool> fetch(String icao) async {
    // Fetch data from NOOA
    String baseUrl =
        'http://www.aviationweather.gov/adds/dataserver_current/httpparam?requestType=retrieve&format=xml&hoursBeforeNow=1&mostRecent=true&stationString=${icao}&dataSource=';
    Map<String, dynamic> wx = {};

    try {
      // METAR
      http.Response response = await http.get('${baseUrl}metars');
      if (response.statusCode == 200) {
        try {
          xml.XmlDocument xmlDoc = xml.parse(response.body);
          wx['metar'] = xmlDoc
              .findAllElements('METAR')
              .single
              .findElements('raw_text')
              .single
              .text;
          wx['flightRules'] = xmlDoc
              .findAllElements('METAR')
              .single
              .findElements('flight_category')
              .single
              .text;
        }
        // if no (METAR) data
        on StateError catch (_) {
          wx['metar'] = 'No data available';
          wx['flightRules'] = '';
        } finally {
          wx['mtFetchTime'] =
              'Fetched on ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc())} UTC';
        }
      } else {
        throw SocketException;
      }
      // TAF
      response = await http.get('${baseUrl}tafs');
      if (response.statusCode == 200) {
        try {
          xml.XmlDocument xmlDoc = xml.parse(response.body);
          wx['taf'] = xmlDoc
              .findAllElements('TAF')
              .single
              .findElements('raw_text')
              .single
              .text;
        }
        // if no (TAF) data
        on StateError catch (_) {
          wx['taf'] = 'No data available';
        } finally {
          wx['tfFetchTime'] =
              'Fetched on ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc())} UTC';
        }
      } else {
        throw SocketException;
      }
      // Write to file
      Map<String, dynamic> allwx = json.decode(_weatherFile.readAsStringSync());
      allwx.addAll({icao: wx});
      _weatherFile.writeAsStringSync(json.encode(allwx));
      return true;
    }
    // if no connection
    on SocketException catch (e) {
      print(e.toString());
      return false;
    }
  }
}

/// NOTAM database (from Pilotweb)
class NotamsProvider {
  static NotamsProvider _notamsProvider;
  static File _notamsFile;

  NotamsProvider._(); // named constructor

  factory NotamsProvider() {
    if (_notamsProvider == null) {
      _notamsProvider =
          NotamsProvider._(); // This is executed only once, singleton object
    }
    return _notamsProvider;
  }

  Future<File> get notamsFile async {
    if (_notamsFile == null) _notamsFile = await init();
    return _notamsFile;
  }

  init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File(join(directory.path, 'data', 'notams.json'));
    // If the file does not exist, create it
    if (!await file.exists()) {
      try {
        await Directory(dirname(file.path)).create(recursive: true);
      } catch (_) {}
      file.writeAsStringSync('{}');
    }
    return file;
  }

  Future<Notam> get(String icao) async {
    // Read the file
    Map<String, dynamic> ntm = json.decode(_notamsFile.readAsStringSync());
    if (ntm.containsKey(icao))
      return Notam.fromMap(ntm[icao]);
    else
      return Notam();
  }

  void clear() {
    // Clear data
    _notamsFile.writeAsStringSync('{}');
  }

  Future<bool> fetch(String icao) async {
    // Query PilotWeb for NOTAMs
    final Map<String, String> query = {
      'reportType': 'RAW',
      'method': 'displayByICAOs',
      'actionType': 'notamRetrievalByICAOs',
      'retrieveLocId': icao,
      'formatType': 'ICAO'
    };
    final uri = Uri.parse(
            'https://pilotweb.nas.faa.gov/PilotWeb/notamRetrievalByICAOAction.do')
        .replace(queryParameters: query);
    Map<String, dynamic> ntm = {};

    try {
      //
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        Document document = parse(response.body);
        List<Element> elems = document.getElementsByTagName('pre');
        List<dynamic> notams = [];
        elems.length == 0
            ? notams.add('No NOTAM available')
            : elems.forEach((el) => notams.add(el.text));
        ntm['notams'] = notams;
        ntm['fetchTime'] =
            'Fetched on ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc())} UTC';
      } else {
        throw SocketException;
      }
      // Write to file
      Map<String, dynamic> allntm = json.decode(_notamsFile.readAsStringSync());
      allntm.addAll({icao: ntm});
      _notamsFile.writeAsStringSync(json.encode(allntm));
      return true;
    }
    // if no connection
    on SocketException catch (_) {
      return false;
    }
  }
}
