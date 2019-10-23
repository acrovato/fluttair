class Database {
  List<String> icaos = [
    'EBLG',
    'EBNM',
    'EBOS',
    'EDDF',
    'EHAM',
    'EHBK',
    'ELLX',
    'LFPG'
  ];
  Map<int, String> aptcati = {
    0: 'Favorites',
    1: 'Belgium',
    2: 'France',
    3: 'Germany',
    4: 'Luxembourg',
    5: 'Netherdlands'
  };
  Map<String, List<String>> aptcats = {
    'Favorites' : [],
    'Belgium': ['EBLG', 'EBNM', 'EBOS'],
    'France': ['LFPG'],
    'Germany': ['EDDF'],
    'Luxembourg': ['ELLX'],
    'Netherdlands': ['EHAM', 'EHBK']
  };
  Map<String, Airport> airports = {
    'EBLG': Airport('EBLG', 'LGG', 'Liège', 'Belgium'),
    'EBNM': Airport('EBNM', 'QNM', 'Namur', 'Belgium'),
    'EBOS': Airport('EBOS', 'OST', 'Oostende', 'Belgium'),
    'EDDF': Airport('EDDF', 'FRA', 'Frankfurt', 'Germany'),
    'EHAM': Airport('EHAM', 'AMS', 'Amsterdam', 'Netherdlands'),
    'EHBK': Airport('EHBK', 'MST', 'Maastricht', 'Netherdlands'),
    'ELLX': Airport('ELLX', 'LUX', 'Luxembourg', 'Luxembourg'),
    'LFPG': Airport('LFPG', 'CDG', 'Charles De Gaule', 'France')
  };

  Map<String, bool> isFav = {
    'EBLG' : false,
    'EBNM' : false,
    'EBOS' : false,
    'EDDF' : false,
    'EHAM' : false,
    'EHBK' : false,
    'ELLX' : false,
    'LFPG' : false
  };
  Map<String, bool> isDate = {
    'EBLG' : false,
    'EBNM' : false,
    'EBOS' : false,
    'EDDF' : false,
    'EHAM' : false,
    'EHBK' : false,
    'ELLX' : false,
    'LFPG' : false
  };
}

class Airport {
  String icao;
  String iata;
  String name;
  String cntry;

  double lat = 0;
  double lng = 0;
  double elv = 0;

  String srsez = '0630';
  String ssetz = '1630';
  String srsel = '0830';
  String ssetl = '1830';

  List<String> rwysi = ['04R', '22L', '04L', '22R'];
  List<String> rwysd = ['12106', '12106', '7677', '7677'];
  List<String> rwyst = ['ASPH', 'ASPH', 'ASPH', 'ASPH'];

  List<String> frqi = ['TWR', 'GND', 'ATIS'];
  List<String> frqf = ['118.130', '121.930', '126.255'];
  List<String> frqc = ['Airport Tower', 'Airport Ground', 'Airport Atis'];

  String ctc = 'Liège Airport\n'
      'Rue de l’Aéroport, 4460 Grâce-Hollogne\n'
      'Belgium\n'
      '+32 4 234 84 11';

  Airport(this.icao, this.iata, this.name, this.cntry);
}
