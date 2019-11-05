class Frequency {
  String callsign;
  String frequency;
  String category;
  String type;

  Frequency.fromMap(Map<String, dynamic> map) {
    callsign = map['callsign'];
    frequency = map['frequency'];
    category = map['category'];
    type = map['type'];
  }
}