import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class Weather {
  final String metar;
  final String taf;
  final String flightRules;
  final Color color;

  Weather({this.metar, this.taf, this.flightRules, this.color});

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
        metar: map['metar'],
        taf: map['taf'],
        flightRules: map['flightRules'],
        color: map['color']);
  }
}

Future<Weather> fetchWeather(icao) async {
  final baseUrl =
      'http://www.aviationweather.gov/adds/dataserver_current/httpparam?requestType=retrieve&format=xml&hoursBeforeNow=1&mostRecent=true&stationString=${icao}&dataSource=';
  final Map<String, dynamic> map = {};

  //TODO: make distinction between exception from http (not connected) and xml (not data available)
  try {
    // get metar and taf from NOOA
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
    } else {
      map['metar'] = 'HTTP error code ${response.statusCode}';
      map['flightRules'] = '';
    }
    response = await http.get('${baseUrl}tafs');
    if (response.statusCode == 200) {
      xml.XmlDocument xmlDoc = xml.parse(response.body);
      map['taf'] = xmlDoc
          .findAllElements('TAF')
          .single
          .findElements('raw_text')
          .single
          .text;
    } else
      map['taf'] = 'HTTP error code ${response.statusCode}';
  }
  // if not connected, set default values
  catch (_) {
    map['metar'] = 'Could not fetch data';
    map['taf'] = 'Could not fetch data';
    map['flightRules'] = '';
  }

  switch (map['flightRules']) {
    case 'VFR':
      {
        map['color'] = Colors.green;
      }
      break;
    case 'MVFR':
      {
        map['color'] = Colors.blue;
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
