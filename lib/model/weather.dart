import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class Weather {
  final String metar;
  final String taf;
  final String flightRules;
  final Color color;
  final String mtFetchTime;
  final String tfFetchTime;

  Weather({this.metar, this.taf, this.flightRules, this.color, this.mtFetchTime, this.tfFetchTime});

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
        metar: map['metar'],
        taf: map['taf'],
        flightRules: map['flightRules'],
        color: map['color'],
        mtFetchTime: map['mtFetchTime'],
        tfFetchTime: map['tfFetchTime']);
  }
}

//TODO: fetch, save and display saved
Future<Weather> fetchWeather(icao) async {
  final baseUrl =
      'http://www.aviationweather.gov/adds/dataserver_current/httpparam?requestType=retrieve&format=xml&hoursBeforeNow=1&mostRecent=true&stationString=${icao}&dataSource=';
  final Map<String, dynamic> map = {};

  // fetch METAR from NOOA
  try {
    http.Response response = await http.get('${baseUrl}metars');
    if (response.statusCode == 200) {
      xml.XmlDocument xmlDoc = xml.parse(response.body);
      map['metar'] = xmlDoc
          .findAllElements('METAR')
          .single
          .findElements('raw_text')
          .single
          .text;
      map['flightRules'] = xmlDoc
          .findAllElements('METAR')
          .single
          .findElements('flight_category')
          .single
          .text;
      map['mtFetchTime'] = 'Fetched on ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc())} UTC';
    } else {
      map['metar'] = 'HTTP error code ${response.statusCode}';
      map['flightRules'] = '';
      map['mtFetchTime'] = '';
    }
  }
  // if no data
  on StateError catch (_) {
    map['metar'] = 'No data available';
    map['flightRules'] = '';
    map['mtFetchTime'] = '';
  }
  // if not connected
  on SocketException catch (_) {
    map['metar'] = 'Could not fetch data: check internet connection';
    map['flightRules'] = '';
    map['mtFetchTime'] = '';
  } catch (e) {
    map['metar'] = e.toString();
    map['flightRules'] = '';
    map['mtFetchTime'] = '';
  }
  // fetch TAF from NOOA
  try {
    http.Response response = await http.get('${baseUrl}tafs');
    if (response.statusCode == 200) {
      xml.XmlDocument xmlDoc = xml.parse(response.body);
      map['taf'] = xmlDoc
          .findAllElements('TAF')
          .single
          .findElements('raw_text')
          .single
          .text;
      map['tfFetchTime'] = 'Fetched on ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc())} UTC';
    } else {
      map['taf'] = 'HTTP error code ${response.statusCode}';
      map['tfFetchTime'] = '';
    }
  }
  // if no data
  on StateError catch (_) {
    map['taf'] = 'No data available';
    map['tfFetchTime'] = '';
  }
  // if not connected
  on SocketException catch (_) {
    map['taf'] = 'Could not fetch data: check internet connection';
    map['tfFetchTime'] = '';
  } catch (e) {
    map['taf'] = e.toString();
    map['tfFetchTime'] = '';
  }

  switch (map['flightRules']) {
    case 'VFR':
      {
        map['color'] = Colors.green;
      }
      break;
    case 'MVFR':
      {
        map['color'] = Colors.blueAccent;
      }
      break;
    case 'IFR':
      {
        map['color'] = Colors.red;
      }
      break;
    case 'LIFR':
      {
        map['color'] = Colors.purple;
      }
      break;

    default:
      {
        map['color'] = Colors.grey;
      }
      break;
  }
  return Weather.fromMap(map);
}
