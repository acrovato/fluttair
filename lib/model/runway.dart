/// Runway data
class Runway {
  final String name; // runway designator (rounded magnetic orientation)
  final String surface; // runway surface type
  final int length; // runway total length
  final String lengthUnit;
  final int width; // runway width
  final String widthUnit;

  Runway(
      {this.name,
      this.surface,
      this.length,
      this.lengthUnit,
      this.width,
      this.widthUnit});

  factory Runway.fromMap(Map<String, dynamic> map) {
    String surface;
    switch (map['surface']) {
      case 'ASPH':
        {
          surface = 'Asphalt';
        }
        break;
      case 'CONC':
        {
          surface = 'Concrete';
        }
        break;
      case 'GRAS':
        {
          surface = 'Grass';
        }
        break;
      case 'GRVL':
        {
          surface = 'Gravel';
        }
        break;
      case 'ICE':
        {
          surface = 'Ice';
        }
        break;
      case 'SAND':
        {
          surface = 'Sand';
        }
        break;
      case 'SNOW':
        {
          surface = 'Snow';
        }
        break;
      case 'SOIL':
        {
          surface = 'Soil';
        }
        break;
      case 'WATE':
        {
          surface = 'Water';
        }
        break;

      default:
        {
          surface = 'Unknown';
        }
        break;
    }
    return Runway(
        name: map['name'],
        surface: surface,
        length: map['length'],
        lengthUnit: map['lengthUnit'],
        width: map['width'],
        widthUnit: map['widthUnit']);
  }
}
