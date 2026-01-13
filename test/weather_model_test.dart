import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:amcdizon_flutter_act1/models/weather.dart';

void main() {
  group('Weather.fromJson', () {
    test('should correctly parse a JSON response from OpenWeatherMap', () {
      // ARRANGE: A realistic sample JSON response from OpenWeatherMap for Manila.
      const String jsonString = '''
      {
        "coord": {
          "lon": 120.9842,
          "lat": 14.5995
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "few clouds",
            "icon": "02d"
          }
        ],
        "base": "stations",
        "main": {
          "temp": 30.83,
          "feels_like": 36.83,
          "temp_min": 29.88,
          "temp_max": 31.07,
          "pressure": 1009,
          "humidity": 66
        },
        "visibility": 10000,
        "wind": {
          "speed": 2.57,
          "deg": 90
        },
        "clouds": {
          "all": 20
        },
        "dt": 1673752934,
        "sys": {
          "type": 2,
          "id": 2009015,
          "country": "PH",
          "sunrise": 1673734894,
          "sunset": 1673775676
        },
        "timezone": 28800,
        "id": 1701668,
        "name": "Manila",
        "cod": 200
      }
      ''';

      // ACT: Decode the JSON and create a Weather object using the factory constructor.
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final weather = Weather.fromJson(jsonMap);

      // ASSERT: Verify that all properties of the Weather object match the expected values.
      expect(weather.cityName, 'Manila');
      expect(weather.temperature, 30.83);
      expect(weather.condition, 'Clouds');
      expect(weather.humidity, 66);
      expect(weather.windSpeed, 2.57);
    });
  });
}