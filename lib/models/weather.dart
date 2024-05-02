
class WeatherData {
  final DateTime date;
  final double temperature;
  final int humidity;
  final double feelsLike;
  final double wind;

  WeatherData({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.feelsLike,
    required this.wind,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] - 273.15),
      humidity: json['main']['humidity'],
      feelsLike: (json['main']['feels_like'] - 273.15),
      wind: json['wind']['speed'],
    );
  }
}