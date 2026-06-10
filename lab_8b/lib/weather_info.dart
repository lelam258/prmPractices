import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherInfo {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final int weatherCode;
  final String cityName;

  const WeatherInfo({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.cityName,
  });
  factory WeatherInfo.fromJson(Map<String, dynamic> json, String city) {
    final current = json['current_weather'];
    return WeatherInfo(
      temperature: (current['temperature'] as num).toDouble(),
      windSpeed: (current['windspeed'] as num).toDouble(),
      weatherCode: (current['weathercode'] as num).toInt(),
      humidity: 65.0,
      cityName: city,
    );
  }

  String get recommendation {
    if (weatherCode >= 51 && weatherCode <= 67 || weatherCode >= 80) {
      return '☔ Rain detected! Please take an umbrella with you today.';
    }
    if (temperature > 35.0) {
      return '🥵 Too hot for outdoor sports! Stay hydrated and stay indoors.';
    }
    if (temperature >= 18.0 && temperature <= 28.0 && windSpeed < 20) {
      return '🍃 Nice weather for a walk or outdoor activities!';
    }
    return '⛅ Weather is stable. Dress comfortably before going out.';
  }

  String get description {
    if (weatherCode == 0) return 'Clear Sky';
    if (weatherCode >= 1 && weatherCode <= 3) return 'Partly Cloudy';
    if (weatherCode >= 45 && weatherCode <= 48) return 'Foggy';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Drizzle / Rain';
    if (weatherCode >= 71 && weatherCode <= 77) return 'Snow Fall';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Rain Showers';
    if (weatherCode >= 95) return 'Thunderstorm';
    return 'Variable Conditions';
  }

  IconData get weatherIcon {
    if (weatherCode == 0) return Icons.wb_sunny_rounded;
    if (weatherCode >= 1 && weatherCode <= 3) return Icons.cloud_queue_rounded;
    if (weatherCode >= 51 && weatherCode <= 67 || weatherCode >= 80) return Icons.umbrella_rounded;
    if (weatherCode >= 95) return Icons.thunderstorm_rounded;
    return Icons.wb_cloudy_rounded;
  }
}