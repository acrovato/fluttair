import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';

// TODO flight as abstract, planned and recorded flight as actual OR merged?
class Flight {
  int id;
  String name;
  String departure;
  String arrival;
  List<LatLng> steerpoints;

  Flight({@required this.id}) {
    name = DateTime.now().toString();
    departure = 'ICAO';
    arrival = 'ICAO';
    steerpoints = [];
  }

  Flight.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    departure = map['departure'];
    arrival = map['arrival'];
    List<double> lat = List.from(map['lat']);
    List<double> lng = List.from(map['lng']);
    steerpoints = [];
    for (int i = 0; i < lat.length; ++i) {
      steerpoints.add(LatLng(lat[i], lng[i]));
    }
  }

  Map<String, dynamic> toMap() {
    List<double> lat = [], lng = [];
    for (var sp in steerpoints) {
      lat.add(sp.latitude);
      lng.add(sp.longitude);
    }
    return {
      'id': id,
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
