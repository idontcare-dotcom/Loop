import 'player.dart';

class Round {
  final int id;
  final String courseName;
  final DateTime date;
  final List<Player> invitedFriends;

  Round({
    required this.id,
    required this.courseName,
    required this.date,
    this.invitedFriends = const [],
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      id: json['id'] as int,
      courseName: json['courseName'] as String,
      date: DateTime.parse(json['date'] as String),
      invitedFriends: (json['invitedFriends'] as List<dynamic>?)
              ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'date': date.toIso8601String(),
      'invitedFriends': invitedFriends.map((e) => e.toJson()).toList(),
    };
  }
}
