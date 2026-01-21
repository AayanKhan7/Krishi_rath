// weather_card.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import for jsonDecode

// You can place the WeatherData class here or in its own file.
class WeatherData {
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final int cloudiness;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.cloudiness,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    double tempInKelvin = json['main']['temp'];
    double tempInCelsius = tempInKelvin - 273.15;
    double windInMps = (json['wind']['speed'] as num).toDouble();
    double windInKph = windInMps * 3.6;

    return WeatherData(
      temperature: tempInCelsius,
      condition: json['weather'][0]['main'] ?? 'Unknown',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: windInKph,
      cloudiness: json['clouds']['all'] ?? 0,
    );
  }
}

class WeatherCard extends StatefulWidget {
  final Position? position;
  const WeatherCard({super.key, this.position});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  String _locationAddress = 'Loading...';
  WeatherData? _weatherData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.position != null) {
      _fetchLocationAndWeather();
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Location not available.';
        _locationAddress = 'Could not get location';
      });
    }
  }

  Future<void> _fetchLocationAndWeather() async {
    // Step 1: Get the human-readable address (same as before)
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.position!.latitude,
        widget.position!.longitude,
      );
      Placemark place = placemarks[0];
      _locationAddress = "${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
    } catch (e) {
      _locationAddress = "Could not get address";
    }

    // Step 2: Fetch weather data from the API
    try {
      final lat = widget.position!.latitude;
      final lon = widget.position!.longitude;
      const apiKey = '8384142489e897127df5756ba76fe04a'; // Your API Key
      final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        _weatherData = WeatherData.fromJson(decodedJson);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print("Error fetching weather: $e");
      _errorMessage = "Could not fetch weather data.";
    }

    // Step 3: Update the UI
    setState(() {
      _isLoading = false;
    });
  }

  // Helper function to get a weather icon based on the condition
  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain; // A rain-like icon
      case 'clear':
        return Icons.wb_sunny;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'drizzle':
        return Icons.shower;
      default:
        return Icons.cloud_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double horizontalMargin = screenWidth * 0.04;
    final double padding = screenWidth * 0.04;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : _buildWeatherContent(screenWidth),
      ),
    );
  }

  Widget _buildWeatherContent(double screenWidth) {
    // Adaptive sizes
    final double mainIconSize = screenWidth * 0.12;
    final double smallIconSize = screenWidth * 0.04;
    final double tempFontSize = screenWidth * 0.08;
    final double conditionFontSize = screenWidth * 0.045;
    final double lastUpdateFontSize = screenWidth * 0.032;
    final double spacing = screenWidth * 0.03;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _locationAddress,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: spacing),
        Row(
          children: [
            Icon(_getWeatherIcon(_weatherData!.condition), size: mainIconSize, color: Colors.blue),
            SizedBox(width: spacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_weatherData!.temperature.toStringAsFixed(0)} °C',
                  style: TextStyle(fontSize: tempFontSize, fontWeight: FontWeight.bold),
                ),
                Text(
                  _weatherData!.condition,
                  style: TextStyle(fontSize: conditionFontSize),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.water_drop, size: smallIconSize, color: Colors.blue.shade300),
                  SizedBox(width: spacing * 0.3),
                  Text('${_weatherData!.humidity}%', style: TextStyle(fontSize: conditionFontSize)),
                ]),
                SizedBox(height: spacing * 0.5),
                Row(children: [
                  Icon(Icons.air, size: smallIconSize),
                  SizedBox(width: spacing * 0.3),
                  Text('${_weatherData!.windSpeed.toStringAsFixed(1)} km/h', style: TextStyle(fontSize: conditionFontSize)),
                ]),
                SizedBox(height: spacing * 0.5),
                Row(children: [
                  Icon(Icons.cloud_queue_outlined, size: smallIconSize),
                  SizedBox(width: spacing * 0.3),
                  Text('${_weatherData!.cloudiness}%', style: TextStyle(fontSize: conditionFontSize)),
                ]),
              ],
            ),
          ],
        ),
        SizedBox(height: spacing),
        const Divider(),
        Text(
          'Updated just now',
          style: TextStyle(fontSize: lastUpdateFontSize, color: Colors.grey),
        ),
      ],
    );
  }
}