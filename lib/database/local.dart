import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

import 'package:fluttair/model/country.dart';
import 'package:fluttair/model/airport.dart';
import 'package:fluttair/model/runway.dart';
import 'package:fluttair/model/frequency.dart';
import 'package:fluttair/model/airspace.dart';
import 'package:fluttair/model/navaid.dart';

class DatabaseProvider {
  static DatabaseProvider _databaseProvider;
  static Database _database;

  DatabaseProvider._(); // named constructor

  factory DatabaseProvider() {
    if (_databaseProvider == null) {
      _databaseProvider =
          DatabaseProvider._(); // This is executed only once, singleton object
    }
    return _databaseProvider;
  }

  Future<Database> get database async {
    if (_database == null) _database = await open();
    return _database;
  }

  open() async {
    // Get path
    var databasesPath = await getDatabasesPath();
    var path0 = join(databasesPath, "lworld.db");
    var path1 = join("assets", "database", "world.db");
    // Copy database from asset to home directory
    // check if dir exists
    try {
      await Directory(dirname(path0)).create(recursive: true);
    } catch (_) {}
    // copy
    ByteData data = await rootBundle.load(path1);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // write and flush the bytes written
    await File(path0).writeAsBytes(bytes, flush: true);
    // Open the database
    return await openDatabase(path0, readOnly: true);
  }

  Future<List<Country>> getCountries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Countries');
    return List.generate(maps.length, (i) {
      return Country.fromMap(maps[i]);
    });
  }

  Future<List<Airport>> getAirports(Country country) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Airports',
        where: "countryId = ?", whereArgs: [country.id], orderBy: 'icao');
    return List.generate(maps.length, (i) {
      return Airport.fromMap(maps[i]);
    });
  }

  Future<List<Runway>> getRunways(Airport airport) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('Runways', where: "airportId = ?", whereArgs: [airport.id]);
    return List.generate(maps.length, (i) {
      return Runway.fromMap(maps[i]);
    });
  }

  Future<List<Frequency>> getFrequencies(Airport airport) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('Frequencies', where: "airportId = ?", whereArgs: [airport.id]);
    return List.generate(maps.length, (i) {
      return Frequency.fromMap(maps[i]);
    });
  }

  Future<List<Airspace>> getAirspaces(Country country) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('Airspaces', where: "countryId = ?", whereArgs: [country.id]);
    return List.generate(maps.length, (i) {
      return Airspace.fromMap(maps[i]);
    });
  }

  Future<List<Navaid>> getNavaids(Country country) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Navaids',
        where: "countryId = ?", whereArgs: [country.id], orderBy: 'callsign');
    return List.generate(maps.length, (i) {
      return Navaid.fromMap(maps[i]);
    });
  }
}
