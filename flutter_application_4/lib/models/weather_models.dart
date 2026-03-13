class WeatherData {
  final CurrentWeather current;
  final List<HourlyPoint> hourly12;
  final List<DailyPoint> daily7;

  WeatherData({
    required this.current,
    required this.hourly12,
    required this.daily7,
  });
}

class CurrentWeather {
  final double temperature;
  final double windSpeed;
  final int weatherCode;

  CurrentWeather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
  });
}

class HourlyPoint {
  final DateTime time;
  final double temperature;

  HourlyPoint({required this.time, required this.temperature});
}

class DailyPoint {
  final DateTime date;
  final double tMax;
  final double tMin;

  DailyPoint({required this.date, required this.tMax, required this.tMin});
}