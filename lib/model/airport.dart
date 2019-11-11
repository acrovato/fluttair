import 'package:flutter_suncalc/flutter_suncalc.dart';
import 'package:intl/intl.dart';

class Airport {
  final int id;
  final String icao;
  final String name;
  final String type;
  final String country;
  final double latitude;
  final double longitude;
  final int elevation;
  final String elevationUnit;
  final String sunriseZ;
  final String sunriseL;
  final String sunsetZ;
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
