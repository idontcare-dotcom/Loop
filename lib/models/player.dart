class Player {
  final int id;
  final String name;
  final String avatar;
  final int? position;
  final int? currentScore;
  final int? holesCompleted;
  final int? totalStrokes;
  final int? scoreToPar;
  final List<int>? rounds;
  final List<int>? holeByHole;
  final bool? isLive;
  final String? lastUpdated;
  final String? trend;
  final bool? isFriend;
  final String? status;
  final int? roundsPlayed;
  final int? totalScore;

  Player({
    required this.id,
    required this.name,
    required this.avatar,
    this.position,
    this.currentScore,
    this.holesCompleted,
    this.totalStrokes,
    this.scoreToPar,
    this.rounds,
    this.holeByHole,
    this.isLive,
    this.lastUpdated,
    this.trend,
    this.isFriend,
    this.status,
    this.roundsPlayed,
    this.totalScore,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      position: json['position'] as int?,
      currentScore: json['currentScore'] as int?,
      holesCompleted: json['holesCompleted'] as int?,
      totalStrokes: json['totalStrokes'] as int?,
      scoreToPar: json['scoreToPar'] as int?,
      rounds: (json['rounds'] as List<dynamic>?)?.map((e) => e as int).toList(),
      holeByHole:
          (json['holeByHole'] as List<dynamic>?)?.map((e) => e as int).toList(),
      isLive: json['isLive'] as bool?,
      lastUpdated: json['lastUpdated'] as String?,
      trend: json['trend'] as String?,
      isFriend: json['isFriend'] as bool?,
      status: json['status'] as String?,
      roundsPlayed: json['roundsPlayed'] as int?,
      totalScore: json['totalScore'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      if (position != null) 'position': position,
      if (currentScore != null) 'currentScore': currentScore,
      if (holesCompleted != null) 'holesCompleted': holesCompleted,
      if (totalStrokes != null) 'totalStrokes': totalStrokes,
      if (scoreToPar != null) 'scoreToPar': scoreToPar,
      if (rounds != null) 'rounds': rounds,
      if (holeByHole != null) 'holeByHole': holeByHole,
      if (isLive != null) 'isLive': isLive,
      if (lastUpdated != null) 'lastUpdated': lastUpdated,
      if (trend != null) 'trend': trend,
      if (isFriend != null) 'isFriend': isFriend,
      if (status != null) 'status': status,
      if (roundsPlayed != null) 'roundsPlayed': roundsPlayed,
      if (totalScore != null) 'totalScore': totalScore,
    };
  }
}
