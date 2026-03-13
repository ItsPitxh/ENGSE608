import 'package:flutter/foundation.dart';
import '../models/weather_models.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherProvider({WeatherService? service}) : _service = service ?? WeatherService();

  final WeatherService _service;

  bool useCelsius = true;

  bool isLoading = false;
  String? error;
  WeatherData? data;

  double lat = 13.7563;
  double lon = 100.5018;
  String city = 'Bangkok';

  void setUnit(bool v) {
    useCelsius = v;
    notifyListeners();
  }

  void setLocation({required String cityName, required double latitude, required double longitude}) {
    city = cityName;
    lat = latitude;
    lon = longitude;
    notifyListeners();
  }

  Future<void> fetch() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      data = await _service.fetchWeather(lat: lat, lon: lon, useCelsius: useCelsius);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}