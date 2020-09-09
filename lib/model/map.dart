import 'dart:io';

/// Map model
class MyMap {
  final int id;
  final String name;
  final File file;

  factory MyMap.fromMap(Map<String, dynamic> map) {
    return MyMap(map['id'], map['name'], map['file']);
  }

  MyMap(this.id, this.name, this.file);
}
