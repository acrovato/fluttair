class Navaid {
  String name;
  String type;
  String callsign;
  double latitude;
  double longitude;
  int elevation;
  String elevationUnit;
  String frequency;
  String channel;
  String range;
  String rangeUnit;

  Navaid.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    callsign = map['callsign'];
    type = map['type'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    elevation = map['elevation'];
    elevationUnit = map['elevationUnit'];
    frequency = map['frequency'];
    channel = map['channel'];
    range = map['range'];
    rangeUnit = map['rangeUnit'];
  }
}
