class Airspace {
  String name;
  String category;
  String ceiling;
  String ceilingUnit;
  String ceilingRef;
  String floor;
  String floorUnit;
  String floorRef;
  List<double> latitude;
  List<double> longitude;

  Airspace.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    category = map['category'];
    ceiling = map['ceiling'];
    ceilingUnit = map['ceilingUnit'];
    ceilingRef = map['ceilingRef'];
    floor = map['floor'];
    floorUnit = map['floorUnit'];
    floorRef = map['floorRef'];
    String lat = map['lat'];
    String lng = map['lng'];
    if (lat != null && lng != null) {
      latitude = lat.split(',').map(double.parse).toList();
      longitude = lng.split(',').map(double.parse).toList();
    } else {
      latitude = [];
      longitude = [];
    }

    //longitude = map['longitude'].split(',').map(double.parse).toList();
  }
}
