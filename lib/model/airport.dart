import 'package:flutter_suncalc/flutter_suncalc.dart';
import 'package:intl/intl.dart';

// TODO: convert type into something user-friendly
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
    var times = SunCalc.getTimes(DateTime.now(), map['latitude'], map['longitude']);
    String sunriseZ = '${DateFormat('HHmm').format(times["sunrise"].toUtc())}Z';
    String sunriseL = '${DateFormat('HHmm').format(times["sunrise"].toLocal())}L';
    String sunsetZ = '${DateFormat('HHmm').format(times["sunset"].toUtc())}Z';
    String sunsetL = '${DateFormat('HHmm').format(times["sunset"].toLocal())}L';

    return Airport(
        id: map['id'],
        icao: map['icao'] ?? '----',
        name: map['name'],
        country: map['country'],
        type: map['type'],
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
