class Weather {
  final DateTime? time;
  final double temperature;
  final String description;
  final String iconUrl;

  Weather({
    this.time,
    required this.temperature,
    required this.description,
    required this.iconUrl,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    DateTime? time = json['current']['time'] != null ? DateTime.parse(json['current']['time']) : null;
    double temperature = json['current']['temperature_2m']?.toDouble() ?? 0.0;
    String description = json['current']['description']?.toString() ?? 'No description available';
    String iconCode = json['current']['weathercode']?.toString() ?? '';
    String iconUrl = _buildIconUrl(iconCode);

    return Weather(
      time: time,
      temperature: temperature,
      description: description,
      iconUrl: iconUrl,
    );
  }

  static String _buildIconUrl(String iconCode) {
    // Implement your logic to build the icon URL based on the iconCode
    // For example: return 'https://example.com/icons/$iconCode.png';
    return 'OOPs! Something went wrong';
  }
}
