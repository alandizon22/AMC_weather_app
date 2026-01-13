class Weather {
  // Make sure the property is named 'cityName' here
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;

  Weather({
    // And also here
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      // The key 'name' from JSON maps to the 'cityName' property
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }
}