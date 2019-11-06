class Frequency {
  final String callsign;
  final String frequency;
  final String category;
  final String type;

  Frequency({this.callsign, this.frequency, this.category, this.type});

  factory Frequency.fromMap(Map<String, dynamic> map) {
    return Frequency(
        callsign: map['callsign'],
        frequency: map['frequency'],
        category: map['category'],
        type: map['type']);
  }
}
