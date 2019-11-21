/// Frequency data
class Frequency {
  final String callsign; // name
  final String frequency; // frequency (MHz)
  final String category; // category (communication, ...)
  final String type; // type (ground, ...)

  Frequency({this.callsign, this.frequency, this.category, this.type});

  factory Frequency.fromMap(Map<String, dynamic> map) {
    return Frequency(
        callsign: map['callsign'],
        frequency: map['frequency'],
        category: map['category'],
        type: map['type']);
  }
}
