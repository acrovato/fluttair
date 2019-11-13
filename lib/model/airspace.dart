/// Airspace data
class Airspace {
  final String name; // airspace name
  final String category; // airspace category (danger, ...)
  final String ceiling; // vertical limits with unit and altimeter setting
  final String ceilingUnit;
  final String ceilingRef;
  final String floor;
  final String floorUnit;
  final String floorRef;
  final List<double> latitude; // geolocation of perimeter points
  final List<double> longitude;

  Airspace(
      {this.name,
      this.category,
      this.ceiling,
      this.ceilingUnit,
      this.ceilingRef,
      this.floor,
      this.floorUnit,
      this.floorRef,
      this.latitude,
      this.longitude});

  factory Airspace.fromMap(Map<String, dynamic> map) {
    String lat = map['lat'];
    String lng = map['lng'];
    List<double> latitude;
    List<double> longitude;
    if (lat != null && lng != null) {
      latitude = lat.split(',').map(double.parse).toList();
      longitude = lng.split(',').map(double.parse).toList();
    } else {
      latitude = [];
      longitude = [];
    }
    return Airspace(
        name: map['name'],
        category: map['category'],
        ceiling: map['ceiling'],
        ceilingUnit: map['ceilingUnit'],
        ceilingRef: map['ceilingRef'],
        floor: map['floor'],
        floorUnit: map['floorUnit'],
        floorRef: map['floorRef'],
        latitude: latitude,
        longitude: longitude);
  }
}
