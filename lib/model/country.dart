class Country {
  int id;
  String name;
  String code;

  Country.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    code = map['code'];
  }
}
