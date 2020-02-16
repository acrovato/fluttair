/// Position class
class Position {
  final double latitude; // D.D
  final double longitude; // D.D
  final double altitude; // m
  final DateTime time; // UTC

  Position(this.latitude, this.longitude, this.altitude, this.time);
}