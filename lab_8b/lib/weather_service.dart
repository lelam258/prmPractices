import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_info.dart';

class WeatherService {
  final Map<String, Map<String, double>> _cityCoordinates = {
    'Hanoi': {'lat': 21.0285, 'lon': 105.8542},
    'Da Nang': {'lat': 16.0544, 'lon': 108.2022},
    'Ho Chi Minh City': {'lat': 10.8231, 'lon': 106.6297},
  };

  List<String> get supportedCities => _cityCoordinates.keys.toList();

  Future<WeatherInfo> fetchWeatherForCity(String city) async {
    final coords = _cityCoordinates[city];
    if (coords == null) {
      throw Exception('City not supported');
    }
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${coords['lat']}&longitude=${coords['lon']}&current_weather=true'
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        return WeatherInfo.fromJson(decodedData, city);
      } else {
        throw Exception('Server error: Code ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Network timeout. Please verify your internet connection.');
    } catch (e) {
      throw Exception('Failed to connect to weather service: $e');
    }
  }
}