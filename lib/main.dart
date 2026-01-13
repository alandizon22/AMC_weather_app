import 'package:flutter/material.dart';
import '../screens/weather_screen.dart'; // Ensure this matches your project structure

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Using a dark theme or deep purple as a starting point for weather apps
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // Set the home to your Weather Screen from weather_screens.dart
      home: const WeatherScreen(),
    );
  }
}