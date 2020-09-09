import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:fluttair/model/flight.dart';

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
      if (entry is File) maps.add(json.decode(entry.readAsStringSync()));
    }
    return List.generate(maps.length, (i) {
      return Flight.fromMap(maps[i]);
    });
  }

  Flight getFlight(int id) {
    // Get flight
    Flight flight;
    List<FileSystemEntity> entries = _flightPath.listSync();
    for (var entry in entries) {
      if (entry is File) {
        Map<String, dynamic> map = json.decode(entry.readAsStringSync());
        flight = Flight.fromMap(map);
        if (flight.id == id) return flight;
      }
    }
    return null;
  }

  Future<int> createFlight() async {
    // Find max id of all existing flights
    List<Flight> flights = await getFlights();
    int newId = 0;
    List<int> ids = List.generate(flights.length, (i) {
      return flights[i].id;
    });
    newId = ids.fold(0, max) + 1;
    // Create using default constructor and save to file
    Map flight = Flight(id: newId).toMap();
    File file = File(join(_flightPath.path, '${flight['id']}'));
    file.writeAsStringSync(json.encode(flight));
    return newId;
  }

  void saveFlight(Flight flight) {
    // Save to disk
    File file = File(join(_flightPath.path, '${flight.id}'));
    file.writeAsStringSync(json.encode(flight.toMap()));
  }

  void deleteFlight(int id) {
    // Delete one flight
    File file = File(join(_flightPath.path, '$id'));
    file.deleteSync();
  }

  void clear() {
    // Delete all flights
    List<FileSystemEntity> entries = _flightPath.listSync();
    for (var entry in entries) entry.deleteSync();
  }
}
