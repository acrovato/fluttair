import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:fluttair/model/map.dart';

/// Map database
class MapProvider {
  static MapProvider _mapProvider;
  static Directory _mapPath;

  MapProvider._(); // named constructor

  factory MapProvider() {
    if (_mapProvider == null) {
      _mapProvider =
          MapProvider._(); // This is executed only once, singleton object
    }
    return _mapProvider;
  }

  Future<Directory> get mapPath async {
    if (_mapPath == null) _mapPath = await init();
    return _mapPath;
  }

  init() async {
    Directory root = await getApplicationDocumentsDirectory();
    Directory dir = Directory(join(root.path, 'maps'));
    // If the path does not exist, create it
    if (!await dir.exists()) {
      try {
        await dir.create(recursive: true);
      } catch (_) {}
    }
    // Get list of maps in asset
    String manifestContent = await rootBundle.loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = json.decode(manifestContent);
    List<String> asset = manifestMap.keys
        .where((String key) => key.contains('maps/'))
        .where((String key) => key.contains('.mbtiles'))
        .toList();
    // Copy map to local
    for (String file in asset) {
      String name = file.split(Platform.pathSeparator).last;
      ByteData data = await rootBundle.load(file);
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(join(dir.path, name)).writeAsBytes(bytes,
          flush: true); // write and flush the bytes written
    }
    return dir;
  }

  String _generateName(String source, String code) {
    String name;
    switch (source) {
      case 'ofm':
        {
          name = 'OpenFlightMap';
        }
        break;
      case 'osm':
        {
          name = 'OpenStreetMap';
        }
        break;
      default:
        {
          name = 'Unknown';
        }
        break;
    }
    switch (code) {
      case 'eb':
        {
          name += ' Belgium';
        }
        break;
      case 'ed':
        {
          name += ' Germany';
        }
        break;
      case 'ef':
        {
          name += ' Finland';
        }
        break;
      case 'eh':
        {
          name += ' Netherlands';
        }
        break;
      case 'ek':
        {
          name += ' Denmark';
        }
        break;
      case 'ep':
        {
          name += ' Poland';
        }
        break;
      case 'es':
        {
          name += ' Sweden';
        }
        break;
      case 'lb':
        {
          name += ' Bulgaria';
        }
        break;
      case 'ld':
        {
          name += ' Croatia';
        }
        break;
      case 'lg':
        {
          name += ' Greece';
        }
        break;
      case 'lh':
        {
          name += ' Hungary';
        }
        break;
      case 'li':
        {
          name += ' Italy';
        }
        break;
      case 'lj':
        {
          name += ' Slovenia';
        }
        break;
      case 'lk':
        {
          name += ' Czech Republic';
        }
        break;
      case 'lm':
        {
          name += ' Malta';
        }
        break;
      case 'lo':
        {
          name += ' Austria';
        }
        break;
      case 'lr':
        {
          name += ' Romania';
        }
        break;
      case 'ls':
        {
          name += ' Switzerland';
        }
        break;
      case 'lz':
        {
          name += ' Slovakia';
        }
        break;
      default:
        {
          name += ' Unknown';
        }
        break;
    }
    return name;
  }

  Future<List<MyMap>> getMaps() async {
    // Get all maps
    List<FileSystemEntity> entries = _mapPath.listSync();
    List<Map<String, dynamic>> maps = [];
    // -shm/-wal get appended to .mbtiles by flutter_map, so we check that we open .mbtiles
    for (int i = 0; i < entries.length; ++i) {
      String filename =
          entries[i].path.split(Platform.pathSeparator).last.split('.')[0];
      if (entries[i].path.split(Platform.pathSeparator).last.split('.')[1] ==
          'mbtiles') {
        String name =
            _generateName(filename.split('_')[0], filename.split('_')[1]);
        maps.add({'id': i, 'name': name, 'file': entries[i]});
      }
    }
    return List.generate(maps.length, (i) {
      return MyMap.fromMap(maps[i]);
    });
  }

  Future<MyMap> getMap(int id) async {
    // Get a map
    List<MyMap> maps = await getMaps();
    return maps[id];
  }
}
