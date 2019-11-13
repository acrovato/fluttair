/// Navaid data
class Navaid {
  final String name; // beacon name
  final String type; // beacon type (VOR, ...)
  final String callsign; // beacon code (usually 3 letters)
  final double latitude; // geolocation
  final double longitude;
  final int elevation;
  final String elevationUnit;
  final String frequency; // frequency (MHz)
  final String channel; // TACAN channel
  final String range; // beacon range
  final String rangeUnit;

  Navaid(
      {this.name,
      this.type,
      this.callsign,
      this.latitude,
      this.longitude,
      this.elevation,
      this.elevationUnit,
      this.frequency,
      this.channel,
      this.range,
      this.rangeUnit});

  factory Navaid.fromMap(Map<String, dynamic> map) {
    return Navaid(
        name: map['name'],
        callsign: map['callsign'],
        type: map['type'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        elevation: map['elevation'],
        elevationUnit: map['elevationUnit'],
        frequency: (map['frequency'] ?? '') == '' ? '-' : map['frequency'],
        channel: map['channel'] ?? '-',
        range: map['range'],
        rangeUnit: map['rangeUnit']);
  }
}
