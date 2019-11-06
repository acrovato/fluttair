class Country {
  final int id;
  final String name;
  final String code;

  Country({this.id, this.name, this.code});

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(id: map['id'], name: map['name'], code: map['code']);
  }
}
