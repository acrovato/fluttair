class Notam {
  final List<dynamic> notams;
  final String fetchTime;

  Notam({this.notams = const [], this.fetchTime = 'No data fetched'});

  factory Notam.fromMap(Map<String, dynamic> map) {
    return Notam(notams: map['notams'], fetchTime: map['fetchTime']);
  }

  Map<String, dynamic> toMap() {
    return {'notams': notams, 'fetchTime': fetchTime};
  }
}
