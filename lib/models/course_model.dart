class CourseModel {
  final String name;
  final double courseRating;
  final int slopeRating;
  final String weather;
  final DateTime teeTime;

  CourseModel({
    required this.name,
    required this.courseRating,
    required this.slopeRating,
    required this.weather,
    required this.teeTime,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      name: json['name'] as String,
      courseRating: (json['courseRating'] as num).toDouble(),
      slopeRating: json['slopeRating'] as int,
      weather: json['weather'] as String,
      teeTime: DateTime.parse(json['teeTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'courseRating': courseRating,
      'slopeRating': slopeRating,
      'weather': weather,
      'teeTime': teeTime.toIso8601String(),
    };
  }
}
