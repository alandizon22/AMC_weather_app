import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';

class WeatherService {
  static const String apiKey = '8e2e4a6f52d181fc68cdc4a343dd0a10';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Weather> getWeather(String cityName) async {
    try {
      // 1. Removed 'final' so the variable can be modified for the CORS proxy
      String url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';

      // 2. Fixed the typo from kIseb to kIsWeb
      if (kIsWeb) {
        url = 'https://corsproxy.io/?' + Uri.encodeComponent(url);
      }

      final http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}