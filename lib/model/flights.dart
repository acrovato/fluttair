import 'package:latlong/latlong.dart';

// TODO flight as abstract, planned and recorded flight as actual OR merged?
class Flight {
  String name;
  String departure;
  String arrival;
  List<dynamic> _steerpoints; // TODO LatLng type fails...

  List<LatLng> get steerpoints {
    return _steerpoints;
  }

  // TODO temp
  set steerpoints(List<LatLng> list) {
    _steerpoints = list;
  }

  Flight() {
    name = DateTime.now().toString();
    departure = 'ICAO';
    arrival = 'ICAO';
    _steerpoints = [LatLng(50.65, 5.45)];
  }

  Flight.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    departure = map['departure'];
    arrival = map['arrival'];
    List<dynamic> lat = map['lat'];
    List<dynamic> lng = map['lng'];
    _steerpoints = [];
    for (int i = 0; i < lat.length; ++i) {
      _steerpoints.add(LatLng(lat[i], lng[i]));
    }
  }

  Map<String, dynamic> toMap() {
    List<double> lat = [], lng = [];
    for (var sp in _steerpoints) {
      lat.add(sp.latitude);
      lng.add(sp.longitude);
    }
    return {
      'name': name,
      'departure': departure,
      'arrival': arrival,
      'lat': lat,
      'lng': lng
    };
  }

  // TODO where to record and stop?
  bool record() {
    return true;
  }

  bool stop() {
    return false;
  }
}
