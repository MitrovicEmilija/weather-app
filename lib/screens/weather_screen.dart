import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:weather_app/screens/forecast_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final dio = Dio();

  var temp = 0;
  var humidity = 0;
  var tempFeelsLike = 0;
  var wind = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    try {
      const apiKey = '6104a06ee8d537d70e46f2cf8537c32d';
      final city = _cityController.text;
      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey',
      );
      Map<String, dynamic> data = jsonDecode(response.toString());
      setState(() {
        temp = data['main']['temp'].round();
        humidity = data['main']['humidity'].round();
        tempFeelsLike = data['main']['feels_like'].round();
        wind = data['wind']['speed'].round();
      });
    } on Exception catch (e) {
      print(e.toString().toUpperCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text('Current weather for ${_cityController.text}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
              )),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForecastScreen(
                            city: _cityController.text,
                            apiKey: '6104a06ee8d537d70e46f2cf8537c32d',
                          )),
                );
              },
              icon: Icon(
                Icons.calendar_today,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ]),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: _cityController,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                        cursorColor: Colors.white70,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: fetchData,
                      child: const Text('Get current weather'),
                    ),
                    const SizedBox(height: 40.0),
                    const Image(
                      image: AssetImage('assets/images/weather-icon-day-with-snow.png'),
                      height: 100,
                    ),
                    const SizedBox(height: 40.0),
                    Text(
                      'Temperature: ${(temp - 273.15).round()} °C',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      'Humidity: $humidity%',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      'Feels Like: ${(tempFeelsLike - 273.15).round()} °C',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      'Wind Speed: $wind m/s',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
  createPost(String text) async {
    try {
      final response = await dio.post('', data: {
        'title': _controller.text,
        'body': 'This is a body of the post',
        'userId': 1,
      });
      if (response.statusCode == 200) {
        print('Post Created: ${response.data}');
        fetchData(); // Refresh the list after creating a post
      }
    } catch (e) {
      print(e);
    }
  }

  updatePost(int id, String newTitle) async {
    try {
      final response = await dio
          .put('https://jsonplaceholder.typicode.com/posts/$id', data: {
        'title': newTitle,
      });
      if (response.statusCode == 200) {
        print('Post Updated: ${response.data}');
        fetchData(); // Refresh the list after updating a post
      }
    } catch (e) {
      print(e);
    }
  }

  deletePost(int id) async {
    try {
      final response =
          await dio.delete('https://jsonplaceholder.typicode.com/posts/$id');
      if (response.statusCode == 200) {
        print('Post Deleted');
        fetchData(); // Refresh the list after deleting a post
      }
    } catch (e) {
      print(e);
    }
  }
   */

/*
Scaffold(
      appBar: AppBar(
        title: Text('Dio CRUD Example App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter post title',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    createPost(_controller.text);
                    _controller.clear();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // For simplicity, we're using the same text field to update. In a real app, you'd want a separate UI for this.
                          updatePost(index + 1, _controller.text);
                          _controller.clear();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deletePost(index + 1);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
 */
