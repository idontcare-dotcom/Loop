class Score {
  final int id;
  final String courseName;
  final DateTime date;
  final int score;
  final int par;
  final String format;
  final String courseImage;

  Score({
    required this.id,
    required this.courseName,
    required this.date,
    required this.score,
    required this.par,
    required this.format,
    required this.courseImage,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      id: json['id'] as int,
      courseName: json['courseName'] as String,
      date: DateTime.parse(json['date'] as String),
      score: json['score'] as int,
      par: json['par'] as int,
      format: json['format'] as String,
      courseImage: json['courseImage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'date': date.toIso8601String(),
      'score': score,
      'par': par,
      'format': format,
      'courseImage': courseImage,
    };
  }
}
