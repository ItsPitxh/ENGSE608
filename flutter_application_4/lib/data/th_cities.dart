class ThaiCity {
  final String name;
  final double lat;
  final double lon;

  const ThaiCity({required this.name, required this.lat, required this.lon});
}

const List<ThaiCity> thCities = [
  ThaiCity(name: 'Bangkok', lat: 13.7563, lon: 100.5018),
  ThaiCity(name: 'Chiang Mai', lat: 18.7883, lon: 98.9853),
  ThaiCity(name: 'Phuket', lat: 7.8804, lon: 98.3923),
  ThaiCity(name: 'Khon Kaen', lat: 16.4419, lon: 102.8350),
];