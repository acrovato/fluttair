import 'dart:io';

/// Map model
class MyMap {
  final String name;
  final File file;

  factory MyMap.fromMap(MapEntry<String, File> map) {
    return MyMap(name: map.key, file: map.value);
  }

  MyMap({this.name, this.file});
}
