class Airport {
  int id;
  String icao;
  String name;
  String type;
  String country;
  double latitude;
  double longitude;
  int elevation;
  String elevationUnit;

  Airport.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    icao = map['icao'] ?? '----';
    name = map['name'];
    country = map['country'];
    type = map['type'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    elevation = map['elevation'];
    elevationUnit = map['elevationUnit'];
  }
}
