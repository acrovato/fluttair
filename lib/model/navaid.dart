class Navaid {
  final String name;
  final String type;
  final String callsign;
  final double latitude;
  final double longitude;
  final int elevation;
  final String elevationUnit;
  final String frequency;
  final String channel;
  final String range;
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
        frequency: map['frequency'],
        channel: map['channel'],
        range: map['range'],
        rangeUnit: map['rangeUnit']);
  }
}
