class WeatherModel {
  final double temperature;
  final String description;
  final String main;
  final int humidity;
  final double windSpeed;
  final String cityName;
  final String icon;
  final double feelsLike;
  final double uv;
  final int visibility;

  WeatherModel({
    required this.temperature,
    required this.description,
    required this.main,
    required this.humidity,
    required this.windSpeed,
    required this.cityName,
    required this.icon,
    required this.feelsLike,
    required this.uv,
    required this.visibility,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['current']['temp_c'] as num).toDouble(),
      description: json['current']['condition']['text'] as String,
      main: json['current']['condition']['text'] as String,
      humidity: json['current']['humidity'] as int,
      windSpeed: (json['current']['wind_kph'] as num).toDouble() /
          3.6, // Convert kph to m/s
      cityName: json['location']['name'] as String,
      icon: json['current']['condition']['icon'] as String,
      feelsLike: (json['current']['feelslike_c'] as num).toDouble(),
      uv: (json['current']['uv'] as num).toDouble(),
      visibility: (json['current']['vis_km'] as num).toInt(),
    );
  }

  String getWeatherIcon() {
    final condition = main.toLowerCase();
    if (condition.contains('sunny') || condition.contains('clear')) {
      return 'wb_sunny';
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return 'cloud';
    } else if (condition.contains('rain') ||
        condition.contains('drizzle') ||
        condition.contains('shower')) {
      return 'umbrella';
    } else if (condition.contains('thunder') || condition.contains('storm')) {
      return 'flash_on';
    } else if (condition.contains('snow') || condition.contains('blizzard')) {
      return 'ac_unit';
    } else if (condition.contains('mist') ||
        condition.contains('fog') ||
        condition.contains('haze')) {
      return 'blur_on';
    } else if (condition.contains('wind')) {
      return 'air';
    } else {
      return 'wb_sunny';
    }
  }

  String getFormattedDescription() {
    return description
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String getWindDirection() {
    // You can extend this to get wind direction from API if needed
    return 'Variable';
  }

  String getUVIndexDescription() {
    if (uv <= 2) {
      return 'Low';
    } else if (uv <= 5) {
      return 'Moderate';
    } else if (uv <= 7) {
      return 'High';
    } else if (uv <= 10) {
      return 'Very High';
    } else {
      return 'Extreme';
    }
  }
}
