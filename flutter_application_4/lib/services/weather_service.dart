import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_models.dart';

class WeatherService {
  static const _base = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherData> fetchWeather({
    required double lat,
    required double lon,
    required bool useCelsius,
  }) async {
    final params = <String, String>{
      'latitude': lat.toString(),
      'longitude': lon.toString(),
      'current': 'temperature_2m,wind_speed_10m,weather_code',
      'hourly': 'temperature_2m',
      'daily': 'temperature_2m_max,temperature_2m_min',
      'forecast_days': '7',
      'timezone': 'Asia/Bangkok',
      'temperature_unit': useCelsius ? 'celsius' : 'fahrenheit',
      'wind_speed_unit': 'kmh',
    };

    final uri = Uri.parse(_base).replace(queryParameters: params);
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;

    // Current
    final currentJson = (json['current'] as Map<String, dynamic>);
    final current = CurrentWeather(
      temperature: (currentJson['temperature_2m'] as num).toDouble(),
      windSpeed: (currentJson['wind_speed_10m'] as num).toDouble(),
      weatherCode: (currentJson['weather_code'] as num).toInt(),
    );

    // Hourly (เลือก 12 ชม.)
    final hourly = (json['hourly'] as Map<String, dynamic>);
    final times = (hourly['time'] as List).cast<String>();
    final temps = (hourly['temperature_2m'] as List).cast<num>();
    final len = times.length < 12 ? times.length : 12;

    final hourly12 = List.generate(len, (i) {
      return HourlyPoint(
        time: DateTime.parse(times[i]),
        temperature: temps[i].toDouble(),
      );
    });

    // Daily (7 วัน)
    final daily = (json['daily'] as Map<String, dynamic>);
    final dTimes = (daily['time'] as List).cast<String>();
    final tMax = (daily['temperature_2m_max'] as List).cast<num>();
    final tMin = (daily['temperature_2m_min'] as List).cast<num>();

    final daily7 = List.generate(dTimes.length, (i) {
      return DailyPoint(
        date: DateTime.parse(dTimes[i]),
        tMax: tMax[i].toDouble(),
        tMin: tMin[i].toDouble(),
      );
    });

    return WeatherData(current: current, hourly12: hourly12, daily7: daily7);
  }
}