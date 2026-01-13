import 'package:flutter/material.dart';
import '../models/weather.dart';
import 'dart:ui';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  late Future<Weather> weatherFuture;
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    weatherFuture = WeatherService.getWeather('London');
  }

  void _searchWeather() {
    final String city = _cityController.text.trim();
    if (city.isEmpty) {
      _showSnackBar('Please enter a city name', Colors.orangeAccent);
      return;
    }
    setState(() {
      weatherFuture = WeatherService.getWeather(city);
      isFirstLoad = false;
    });
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows gradient to show under status bar
      appBar: AppBar(
        title: const Text(
          'WEATHER FORECAST',
          style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              fontSize: 18,
              color: Colors.white
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Enhanced background color: Deep blue to light sky gradient
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade500,
              Colors.lightBlue.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                // ===== ENHANCED SEARCH BAR =====
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cityController,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            hintText: 'Search city...',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.white70),
                          ),
                          onSubmitted: (_) => _searchWeather(),
                        ),
                      ),
                      IconButton(
                        onPressed: _searchWeather,
                        icon: const Icon(Icons.send, color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // ===== WEATHER DISPLAY SECTION =====
                FutureBuilder<Weather>(
                  future: weatherFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }

                    if (snapshot.hasError) {
                      return _buildErrorWidget(snapshot.error.toString());
                    }

                    if (snapshot.hasData) {
                      final weather = snapshot.data!;
                      return Column(
                        children: [
                          _buildGlassCard(
                            child: Column(
                              children: [
                                // City Name: Wide spacing, light weight
                                Text(
                                  weather.cityName.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    letterSpacing: 5,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Temperature: Large, Bold focus
                                Text(
                                  '${weather.temperature.toStringAsFixed(0)}°',
                                  style: const TextStyle(
                                    fontSize: 100,
                                    fontWeight: FontWeight.w200, // Thin modern look
                                    color: Colors.white,
                                  ),
                                ),

                                // Condition
                                Text(
                                  weather.condition.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 40),

                                // Additional Info Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildDetailColumn(Icons.water_drop, '${weather.humidity}%', 'HUMIDITY'),
                                    _buildDetailColumn(Icons.air, '${weather.windSpeed} m/s', 'WIND'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const Text('Search for a city', style: TextStyle(color: Colors.white));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // GLASSMORPHISM HELPER WIDGET
  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildDetailColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
        ),
        Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 1)
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String error) {
    return Column(
      children: [
        const Icon(Icons.cloud_off, size: 80, color: Colors.white54),
        const SizedBox(height: 20),
        Text(
          error.contains('404') ? 'CITY NOT FOUND' : 'SOMETHING WENT WRONG',
          style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 2),
        ),
      ],
    );
  }
}
