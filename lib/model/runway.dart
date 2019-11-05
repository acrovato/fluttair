class Runway {
  String name;
  String surface;
  int length;
  String lengthUnit;
  int width;
  String widthUnit;

  Runway.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    surface = map['surface'];
    length = map['length'];
    lengthUnit = map['lengthUnit'];
    width = map['width'];
    widthUnit = map['widthUnit'];
  }
}