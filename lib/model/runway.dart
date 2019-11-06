class Runway {
  final String name;
  final String surface;
  final int length;
  final String lengthUnit;
  final int width;
  final String widthUnit;

  Runway(
      {this.name,
      this.surface,
      this.length,
      this.lengthUnit,
      this.width,
      this.widthUnit});

  factory Runway.fromMap(Map<String, dynamic> map) {
    return Runway(
        name: map['name'],
        surface: map['surface'],
        length: map['length'],
        lengthUnit: map['lengthUnit'],
        width: map['width'],
        widthUnit: map['widthUnit']);
  }
}
