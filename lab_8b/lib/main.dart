import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'weather_info.dart';
import 'weather_service.dart';

void main() {
  runApp(const WeatherCompanionApp());
}
class WeatherCompanionApp extends StatelessWidget {
  const WeatherCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
      ),
      home: const WeatherMainScreen(),
    );
  }
}

class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({super.key});

  @override
  State<WeatherMainScreen> createState() => _WeatherMainScreenState();
}

class _WeatherMainScreenState extends State<WeatherMainScreen> {
  final WeatherService _weatherService = WeatherService();
  late String _selectedCity;
  late Future<WeatherInfo> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _selectedCity = _weatherService.supportedCities.first;
    _loadWeatherData();
  }

  void _loadWeatherData() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeatherForCity(_selectedCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Companion', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blueAccent),
                        SizedBox(width: 8),
                        Text('Select Region:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      ],
                    ),
                    DropdownButton<String>(
                      value: _selectedCity,
                      underline: const SizedBox(),
                      onChanged: (String? newCity) {
                        if (newCity != null) {
                          setState(() {
                            _selectedCity = newCity;
                            _loadWeatherData();
                          });
                        }
                      },
                      items: _weatherService.supportedCities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: FutureBuilder<WeatherInfo>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.blueAccent),
                          SizedBox(height: 16),
                          Text('Loading localized weather data...', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    );
                  }

                  else if (snapshot.hasError) {
                    return Center(
                      child: Card(
                        color: Colors.red[50],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.redAccent),
                              const SizedBox(height: 16),
                              const Text('Failed to Fetch Weather',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                              const SizedBox(height: 8),
                              Text('${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black87)),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: _loadWeatherData,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Try Again'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  else if (snapshot.hasData) {
                    final weather = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.lightBlueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  children: [
                                    Text(weather.cityName,
                                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                                    const SizedBox(height: 10),
                                    Icon(weather.weatherIcon, size: 80, color: Colors.white),
                                    const SizedBox(height: 10),
                                    Text('${weather.temperature}°C',
                                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white)),
                                    Text(weather.description,
                                        style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Card(
                            color: Colors.amber[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Colors.amber, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.assistant_navigation, color: Colors.amber),
                                      const SizedBox(width: 8),
                                      Text('Smart Companion Recommendation:',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber[700])),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    weather.recommendation,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  icon: Icons.water_drop,
                                  title: 'Humidity',
                                  value: '${weather.humidity}%',
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoCard(
                                  icon: Icons.air,
                                  title: 'Wind Speed',
                                  value: '${weather.windSpeed} km/h',
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(child: Text('No structured data found.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoCard({required IconData icon, required String title, required String value, required Color color}) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.black54, fontSize: 14)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
extension on Colors {
  static const Color redDeep = Color(0xFFC62828);
  static const Color amberScale = Color(0xFFFFB300);
  static const Color amberDark = Color(0xFFFF8F00);
}