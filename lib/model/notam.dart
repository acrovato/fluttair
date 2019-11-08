import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class Notam {
  final List<String> notams;
  String fetchTime;

  Notam({this.notams, this.fetchTime});

  factory Notam.fromMap(Map<String, dynamic> map) {
    return Notam(notams: map['notams'], fetchTime: map['fetchTime']);
  }
}

//TODO: fetch, save and display saved
Future<Notam> fetchNotam(icao) async {
  // Query PilotWeb for NOTAMs
  final Map<String, String> query = {
    'reportType': 'RAW',
    'method': 'displayByICAOs',
    'actionType': 'notamRetrievalByICAOs',
    'retrieveLocId': icao,
    'formatType': 'ICAO'
  };
  final uri = Uri.parse(
          'https://pilotweb.nas.faa.gov/PilotWeb/notamRetrievalByICAOAction.do')
      .replace(queryParameters: query);

  // Parse response
  try {
    http.Response response = await http.get(uri);
    Document document = parse(response.body);
    List<Element> elems = document.getElementsByTagName('pre');
    List<String> notams = [];
    elems.length == 0
        ? notams.add('No NOTAM available')
        : elems.forEach((el) => notams.add(el.text));
    return Notam.fromMap({
      'notams': notams,
      'fetchTime':
          'Fetched on ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc())} UTC'
    });
  } on SocketException catch (_) {
    return Notam.fromMap({
      'notams': ['Could not fetch data: check internet connection'],
      'fetchTime': ''
    });
  }
}
