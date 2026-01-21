// A simple data model to hold the weather information from the API.

class WeatherData {
  final double temperature; // In Celsius
  final String condition;   // e.g., "Clouds", "Rain"
  final int humidity;       // In percentage
  final double windSpeed;   // In km/h
  final int cloudiness;     // In percentage

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.cloudiness,
  });

  // A 'factory constructor' to create a WeatherData object from the JSON map.
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    // Conversion from Kelvin to Celsius
    double tempInKelvin = json['main']['temp'];
    double tempInCelsius = tempInKelvin - 273.15;

    // Conversion from meter/sec to km/h
    double windInMps = json['wind']['speed'];
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