import 'package:flutter/material.dart';
import 'package:weather_forcast/forecast.dart';
import 'package:weather_forcast/weather.dart';
import 'package:weather_forcast/weather_api.dart';
import 'package:weather_forcast/weather_card.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherApi _weatherApi = WeatherApi();
  Weather? _currentWeather;
  List<Forecast?>? _weatherForecast;
  bool _locationServiceEnabled = false;

  @override
  void initState() {
    super.initState();
    _currentWeather = null;
    _weatherForecast = null;
    _checkLocationService();
  }

  Future<void> _checkLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        setState(() {
          _locationServiceEnabled = false;
        });
        return;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationServiceEnabled = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationServiceEnabled = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _locationServiceEnabled = true;
    });

    _loadWeatherData(position.latitude, position.longitude);
  }

 Future<void> _loadWeatherData(double latitude, double longitude) async {
  try {
    Map<String, dynamic>? weatherDataJson = await _weatherApi.fetchCurrentWeather(latitude, longitude);
    Map<String, dynamic>? forecastDataJson = await _weatherApi.fetchWeatherForecast(latitude, longitude);

    if (weatherDataJson == null || forecastDataJson == null) {
      print('Weather data or forecast data is null.');
      return;
    }

    // Ensure that forecastDataJson['daily'] is not null and has the expected structure
    var dailyData = forecastDataJson['daily'];
    if (dailyData == null) {
      print('Daily data is null.');
      return;
    }

    // Parse current weather data
    Forecast currentWeatherData = Forecast(
      date: DateTime.now(), // Assuming current date/time for the current weather
      maxTemperature: (dailyData['temperature_2m_max'] as List<dynamic>)[0]?.toDouble() ?? 0.0,
      minTemperature: (dailyData['temperature_2m_min'] as List<dynamic>)[0]?.toDouble() ?? 0.0,
      description: (dailyData['weathercode'] as List<dynamic>)[0]?.toString() ?? 'No description available',
    );

    // Parse forecast data for the next 3 days
    List<Forecast?> forecastData = List.generate(3, (index) {
      var forecastTime = (dailyData['time'] as List<dynamic>)[index + 1];
      var maxTemperature = (dailyData['temperature_2m_max'] as List<dynamic>)[index + 1];
      var minTemperature = (dailyData['temperature_2m_min'] as List<dynamic>)[index + 1];
      var description = (dailyData['weathercode'] as List<dynamic>)[index + 1];

      return Forecast(
        date: DateTime.parse(forecastTime),
        maxTemperature: maxTemperature?.toDouble() ?? 0.0,
        minTemperature: minTemperature?.toDouble() ?? 0.0,
        description: description?.toString() ?? 'No description available',
      );
    });

    forecastData.insert(0, currentWeatherData); // Insert current weather data at the beginning of the list

    setState(() {
      _weatherForecast = forecastData;
    });
  } catch (e) {
    print('Error fetching weather data: $e');
  }
}

  String _buildIconUrl(String weatherCode) {
    // Implement logic to build icon URL based on weather code
    // Return the appropriate URL here
    return '';
  }

  void _refreshWeatherData() {
    _checkLocationService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: _locationServiceEnabled
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentWeather != null)
                    WeatherCard(weatherData: _currentWeather),
                  if (_weatherForecast != null)
                    Column(
                      children: _weatherForecast!.map((forecast) {
                        return WeatherCard(weatherData: forecast);
                      }).toList(),
                    ),
                  ElevatedButton(
                    onPressed: _refreshWeatherData,
                    child: Text('Refresh Weather'),
                  ),
                ],
              )
            : Text('Location service is disabled.'),
      ),
    );
  }
}
