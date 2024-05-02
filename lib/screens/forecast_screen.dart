import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:weather_app/models/weather.dart';

final formatter = DateFormat('yyyy-MM-dd HH:mm');

class ForecastScreen extends StatefulWidget {
  final String city;
  final String apiKey;

  const ForecastScreen({super.key, required this.city, required this.apiKey});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  List<WeatherData> forecastData = [];
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchForecastData();
  }

  Future<void> fetchForecastData() async {
    try {
      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/forecast?q=${widget.city}&appid=${widget.apiKey}',
      );
      final Map<String, dynamic> data = jsonDecode(response.toString());
      final List<dynamic> list = data['list'];
      final List<WeatherData> forecast =
          list.map((item) => WeatherData.fromJson(item)).toList();

      setState(() {
        forecastData = forecast;
      });
    } on Exception catch (e) {
      print(e.toString().toUpperCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forecast for ${widget.city}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
            itemCount: forecastData.length,
            itemBuilder: (context, index) {
              if (forecastData.isEmpty) {
                return const Text(
                  'No data available',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                );
              }
              return ListTile(
                  title: Text(
                    "${formatter.format(forecastData[index].date)}h",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Temperature: ${forecastData[index].temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Feels like: ${forecastData[index].feelsLike.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Humidity: ${forecastData[index].humidity.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Wind: ${forecastData[index].wind.toStringAsFixed(1)} m/s',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white70,
                          ),
                        ),
                      ]));
            }),
      ),
    );
  }
}
