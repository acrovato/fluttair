import 'package:flutter/material.dart';

/// Weather data
class Weather {
  final String metar; // station METAR (raw text)
  final String taf; // station TAF (ra text)
  final String flightRules; // flight rules (VFR, ...)
  final String mtFetchTime; // time at which data where downloaded
  final String tfFetchTime;

  Weather(
      {this.metar = '',
      this.taf = '',
      this.flightRules = '',
      this.mtFetchTime = 'No data fetched',
      this.tfFetchTime = 'No data fetched'});

  factory Weather.fromMap(Map<String, dynamic> map) {
    //TODO add linebreaks on keywords?
    return Weather(
        metar: map['metar'],
        taf: map['taf'],
        flightRules: map['flightRules'],
        mtFetchTime: map['mtFetchTime'],
        tfFetchTime: map['tfFetchTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      'metar': metar,
      'taf': taf,
      'flightRules': flightRules,
      'mtFetchTime': mtFetchTime,
      'tfFetchTime': tfFetchTime
    };
  }

  Color getFlightRulesColor() {
    switch (flightRules) {
      case 'VFR':
        {
          return Colors.green;
        }
        break;
      case 'MVFR':
        {
          return Colors.blue;
        }
        break;
      case 'IFR':
        {
          return Colors.red;
        }
        break;
      case 'LIFR':
        {
          return Colors.purple;
        }
        break;

      default:
        {
          return Colors.grey;
        }
        break;
    }
  }
}
