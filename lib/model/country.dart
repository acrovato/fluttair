/// Country data
class Country {
  final int id; // database key
  final String name; // country name
  final String code; // county code (2 letters)

  Country({this.id, this.name, this.code});

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(id: map['id'], name: map['name'], code: map['code']);
  }
}
