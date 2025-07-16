import 'dart:math';

class PlayerModel {
  final String id;
  final String name;
  final double handicapIndex;
  final List<int> recentScores;
  final String? avatarUrl;

  PlayerModel({
    required this.id,
    required this.name,
    required this.handicapIndex,
    this.recentScores = const [],
    this.avatarUrl,
  });

  double get averageScore {
    if (recentScores.isEmpty) return 85.0;
    return recentScores.reduce((a, b) => a + b) / recentScores.length;
  }

  double get scoreDeviation {
    if (recentScores.length < 2) return 3.5;
    final avg = averageScore;
    final variance = recentScores
            .map((score) => (score - avg) * (score - avg))
            .reduce((a, b) => a + b) /
        recentScores.length;
    return sqrt(variance);
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      handicapIndex: (json['handicapIndex'] as num).toDouble(),
      recentScores: List<int>.from(json['recentScores'] ?? []),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handicapIndex': handicapIndex,
      'recentScores': recentScores,
      'avatarUrl': avatarUrl,
    };
  }
}
