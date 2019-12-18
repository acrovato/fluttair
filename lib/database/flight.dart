import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:fluttair/model/flights.dart';

/// Flight database
class FlightProvider {
  static FlightProvider _flightProvider;
  static Directory _flightPath;

  FlightProvider._(); // named constructor

  factory FlightProvider() {
    if (_flightProvider == null) {
      _flightProvider =
          FlightProvider._(); // This is executed only once, singleton object
    }
    return _flightProvider;
  }

  Future<Directory> get flightPath async {
    if (_flightPath == null) _flightPath = await init();
    return _flightPath;
  }

  init() async {
    Directory root = await getApplicationDocumentsDirectory();
    Directory dir = Directory(join(root.path, 'flights'));
    // If the path does not exist, create it
    if (!await dir.exists()) {
      try {
        await dir.create(recursive: true);
      } catch (_) {}
    }
    return dir;
  }

  Future<List<Flight>> getFlights() async {
    // Get all flights
    List<FileSystemEntity> entries = _flightPath.listSync();
    List<Map<String, dynamic>> maps = [];
    for (var entry in entries) {
      if (entry is File)
        maps.add(json.decode(entry.readAsStringSync()));
    }
    return List.generate(maps.length, (i) {
      return Flight.fromMap(maps[i]);
    });
  }

  void createFlight() {
    // Create using default constructor and save to file
    Map flight = Flight().toMap();
    File file = File(join(_flightPath.path, flight['name']));
    file.writeAsStringSync(json.encode(flight));
  }

  void saveFlight(Flight flight) {
    // Save to disk
    File file = File(join(_flightPath.path, flight.name));
    file.writeAsStringSync(json.encode(flight.toMap()));
  }

  void deleteFlight(String name) {
    // Delete one flight
    File file = File(join(_flightPath.path, name));
    file.deleteSync();
  }

  void clear() {
    // Delete all flights
    List<FileSystemEntity> entries = _flightPath.listSync();
    for (var entry in entries) entry.deleteSync();
  }
}