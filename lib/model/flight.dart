import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:fluttair/model/position.dart';

// TODO flight as abstract, planned and recorded flight as actual OR merged?
class Flight {
  int id;
  String name;
  String departure;
  String arrival;
  List<LatLng> steerpoints;
  List<Position> track;

  Flight({@required this.id}) {
    name = DateTime.now().toString();
    departure = '';
    arrival = '';
    steerpoints = [];
    track = [];
  }

  Flight.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    departure = map['departure'];
    arrival = map['arrival'];
    List<double> lats = List.from(map['lats']);
    List<double> lngs = List.from(map['lngs']);
    steerpoints = [];
    for (int i = 0; i < lats.length; ++i) {
      steerpoints.add(LatLng(lats[i], lngs[i]));
    }
    List<double> latt = List.from(map['latt']);
    List<double> lngt = List.from(map['lngt']);
    List<double> altt = List.from(map['altt']);
    track = [];
    for (int i = 0; i < latt.length; ++i) {
      track.add(Position(latt[i], lngt[i], altt[i]));
    }
  }

  Map<String, dynamic> toMap() {
    List<double> lats = [], lngs = [];
    for (var sp in steerpoints) {
      lats.add(sp.latitude);
      lngs.add(sp.longitude);
    }
    List<double> latt = [], lngt = [], altt = [];
    for (var tp in track) {
      latt.add(tp.latitude);
      lngt.add(tp.longitude);
      altt.add(tp.altitude);
    }
    return {
      'id': id,
      'name': name,
      'departure': departure,
      'arrival': arrival,
      'lats': lats,
      'lngs': lngs,
      'latt': latt,
      'lngt': lngt,
      'altt': altt
    };
  }

  void record(double lat, double lng, double alt) {
    track.add(Position(lat, lng, alt));
  }
}
