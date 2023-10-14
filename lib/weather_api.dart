import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherApi {
  final String baseUrl = 'https://api.open-meteo.com/v1';

  Future<Map<String, dynamic>> fetchCurrentWeather(
      double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m&timezone=auto'));
    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load current weather data');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherForecast(
      double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/forecast?latitude=$latitude&longitude=$longitude&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=auto'));
    if (response.statusCode == 200) {
       print('Response Body: ${response.body}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather forecast data');
    }
  }
}
