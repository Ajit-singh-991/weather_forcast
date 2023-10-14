class Forecast {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final String description;

  Forecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.description,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.parse(json['date']),
      maxTemperature: json['temperature_2m_max'] as double,
      minTemperature: json['temperature_2m_min'] as double,
      description: json['description'] as String,
    );
  }
}
