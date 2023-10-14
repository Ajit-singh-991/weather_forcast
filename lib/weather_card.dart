import 'package:flutter/material.dart';
import 'package:weather_forcast/forecast.dart';
import 'package:weather_forcast/weather.dart';

class WeatherCard extends StatelessWidget {
  final dynamic weatherData; // Can be Weather or Forecast object

  WeatherCard({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    String temperature = '';
    String description = '';
    String iconUrl = '';

    if (weatherData is Weather) {
      temperature = weatherData.temperature.toString();
      description = weatherData.description;
      iconUrl = weatherData.iconUrl;
    } else if (weatherData is Forecast) {
      temperature = '${weatherData.minTemperature} - ${weatherData.maxTemperature}';
      description = weatherData.description;
      // You might want to handle the date here as well for forecasts
    }

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (iconUrl.isNotEmpty)
              Image.network(
                iconUrl,
                height: 50,
                width: 50,
              ),
            Text(
              'Temperature: $temperature°C',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
