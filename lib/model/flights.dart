import 'package:latlong/latlong.dart';

// TODO flight as abstract, planned and recorded flight as actual OR merged?
class Flight {
  List<LatLng> _steerpoints;

  List<LatLng> get steerpoints {
    return _steerpoints;
  }

  Flight(this._steerpoints);

  bool record() {
    return true;
  }
  bool stop() {
    return false;
  }
}