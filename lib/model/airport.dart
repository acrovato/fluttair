import 'package:flutter_suncalc/flutter_suncalc.dart';
import 'package:intl/intl.dart';

/// Airport data
class Airport {
  final int id; // database key
  final String icao; // ICAO code
  final String name; // airport name
  final String type; // airport type (civil, ...)
  final String country; // country where the airport is
  final double latitude; // geolocation
  final double longitude;
  final int elevation;
  final String elevationUnit;
  final String sunriseZ; // sunrise time UTC and local
  final String sunriseL;
  final String sunsetZ; // sunset time UTC and local
  final String sunsetL;

  Airport(
      {this.id,
      this.icao,
      this.name,
      this.type,
      this.country,
      this.latitude,
      this.longitude,
      this.elevation,
      this.elevationUnit,
      this.sunriseZ,
      this.sunriseL,
      this.sunsetZ,
      this.sunsetL});

  factory Airport.fromMap(Map<String, dynamic> map) {
    var times =
        SunCalc.getTimes(DateTime.now(), map['latitude'], map['longitude']);
    String sunriseZ = '${DateFormat('HHmm').format(times["sunrise"].toUtc())}Z';
    String sunriseL =
        '${DateFormat('HHmm').format(times["sunrise"].toLocal())}L';
    String sunsetZ = '${DateFormat('HHmm').format(times["sunset"].toUtc())}Z';
    String sunsetL = '${DateFormat('HHmm').format(times["sunset"].toLocal())}L';

    String type;
    switch (map['type']) {
      case 'AD_CLOSED':
        {
          type = 'Aerodrome (closed)';
        }
        break;
      case 'AD_MIL':
        {
          type = 'Aerodrome (military)';
        }
        break;
      case 'AF_CIVIL':
        {
          type = 'Aerodrome (civil)';
        }
        break;
      case 'AF_MIL_CIVIL':
        {
          type = 'Aerodrome (military/civil)';
        }
        break;
      case 'AF_WATER':
        {
          type = 'Hydrobase';
        }
        break;
      case 'GLIDING':
        {
          type = 'Glider site';
        }
        break;
      case 'HELI_CIVIL':
        {
          type = 'Heliport (civil)';
        }
        break;
      case 'HELI_MIL':
        {
          type = 'Heliport (military)';
        }
        break;
      case 'INTL_APT':
        {
          type = 'International airport';
        }
        break;
      case 'LIGHT_AIRCRAFT':
        {
          type = 'ULM site';
        }
        break;

      default:
        {
          type = map['type'];
        }
        break;
    }

    return Airport(
        id: map['id'],
        icao: map['icao'] ?? '----',
        name: map['name'],
        country: map['country'],
        type: type,
        latitude: map['latitude'],
        longitude: map['longitude'],
        elevation: map['elevation'],
        elevationUnit: map['elevationUnit'],
        sunriseZ: sunriseZ,
        sunriseL: sunriseL,
        sunsetZ: sunsetZ,
        sunsetL: sunsetL);
  }
}
