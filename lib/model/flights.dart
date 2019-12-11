import 'package:latlong/latlong.dart';

// TODO flight as abstract, planned and recorded flight as actual OR merged?
// TODO save/write/track operations in database?
class Flight {
  String name;
  String departure;
  String arrival;
  List<LatLng> _steerpoints;

  List<LatLng> get steerpoints {
    return _steerpoints;
  }

  Flight(this._steerpoints) {name = 'Dummy flight'; departure = 'EBLG'; arrival = 'EBNM';}
  
  bool record() {
    return true;
  }
  bool stop() {
    return false;
  }
}