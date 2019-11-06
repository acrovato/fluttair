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

  // TODO: https://pub.dev/documentation/flutter_suncalc/latest/ to get timezone

  Airport(
      {this.id,
      this.icao,
      this.name,
      this.type,
      this.country,
      this.latitude,
      this.longitude,
      this.elevation,
      this.elevationUnit});

  factory Airport.fromMap(Map<String, dynamic> map) {
    return Airport(
        id: map['id'],
        icao: map['icao'] ?? '----',
        name: map['name'],
        country: map['country'],
        type: map['type'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        elevation: map['elevation'],
        elevationUnit: map['elevationUnit']);
  }
}
