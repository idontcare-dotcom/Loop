import './player_model.dart';

class SimulationResultModel {
  final PlayerModel player;
  final double expectedScore;
  final String mostLikelyScoreRange;
  final double winProbability;
  final double courseHandicap;

  SimulationResultModel({
    required this.player,
    required this.expectedScore,
    required this.mostLikelyScoreRange,
    required this.winProbability,
    required this.courseHandicap,
  });

  factory SimulationResultModel.create({
    required PlayerModel player,
    required double courseRating,
    required int slopeRating,
    required double winProbability,
  }) {
    final courseHandicap = player.handicapIndex * (slopeRating / 113);
    final expectedScore = courseRating + (courseHandicap * 0.93);
    final lowerBound = (expectedScore - 2).round();
    final upperBound = (expectedScore + 2).round();
    final mostLikelyScoreRange = '$lowerBound–$upperBound';

    return SimulationResultModel(
      player: player,
      expectedScore: expectedScore,
      mostLikelyScoreRange: mostLikelyScoreRange,
      winProbability: winProbability,
      courseHandicap: courseHandicap,
    );
  }
}

class HeadToHeadResult {
  final PlayerModel player1;
  final PlayerModel player2;
  final double player1WinPercentage;
  final double player2WinPercentage;
  final double averageScoreDifferential;

  HeadToHeadResult({
    required this.player1,
    required this.player2,
    required this.player1WinPercentage,
    required this.player2WinPercentage,
    required this.averageScoreDifferential,
  });
}
