import 'dart:math';
import '../models/player_model.dart';
import '../models/course_model.dart';
import '../models/simulation_result_model.dart';

class MonteCarloSimulationService {
  static const int _simulationRounds = 1000;
  final Random _random = Random();

  /// Generates a normally distributed random number using Box-Muller transform
  double _randomNormal(double mean, double standardDeviation) {
    double u1 = _random.nextDouble();
    double u2 = _random.nextDouble();

    // Ensure u1 is not zero for log calculation
    while (u1 <= 0) {
      u1 = _random.nextDouble();
    }

    double z0 = sqrt(-2 * log(u1)) * cos(2 * pi * u2);
    return mean + z0 * standardDeviation;
  }

  /// Simulates scores for a single player
  List<double> _simulatePlayerRounds(PlayerModel player, CourseModel course) {
    final courseHandicap = player.handicapIndex * (course.slopeRating / 113);
    final expectedScore = course.courseRating + (courseHandicap * 0.93);

    // Adjust deviation based on weather conditions
    double deviation = player.scoreDeviation;
    switch (course.weather.toLowerCase()) {
      case 'rainy':
        deviation *= 1.4;
        break;
      case 'windy':
        deviation *= 1.2;
        break;
      case 'cloudy':
        deviation *= 1.1;
        break;
      case 'clear':
      default:
        // No adjustment for clear weather
        break;
    }

    return List.generate(
        _simulationRounds, (index) => _randomNormal(expectedScore, deviation));
  }

  /// Runs Monte Carlo simulation for multiple players
  List<SimulationResultModel> runSimulation(
    List<PlayerModel> players,
    CourseModel course,
  ) {
    if (players.isEmpty) return [];

    // Generate simulation results for each player
    final Map<PlayerModel, List<double>> playerSimulations = {};
    for (final player in players) {
      playerSimulations[player] = _simulatePlayerRounds(player, course);
    }

    // Calculate win probabilities
    final Map<PlayerModel, int> winCounts = {};
    for (final player in players) {
      winCounts[player] = 0;
    }

    // Count wins for each simulation round
    for (int round = 0; round < _simulationRounds; round++) {
      PlayerModel? winner;
      double bestScore = double.infinity;

      for (final player in players) {
        final score = playerSimulations[player]![round];
        if (score < bestScore) {
          bestScore = score;
          winner = player;
        }
      }

      if (winner != null) {
        winCounts[winner] = winCounts[winner]! + 1;
      }
    }

    // Create results
    final results = players.map((player) {
      final winProbability = (winCounts[player]! / _simulationRounds) * 100;
      return SimulationResultModel.create(
        player: player,
        courseRating: course.courseRating,
        slopeRating: course.slopeRating,
        winProbability: winProbability,
      );
    }).toList();

    // Sort by win probability (highest first)
    results.sort((a, b) => b.winProbability.compareTo(a.winProbability));

    return results;
  }

  /// Runs head-to-head simulation between two players
  HeadToHeadResult runHeadToHeadSimulation(
    PlayerModel player1,
    PlayerModel player2,
    CourseModel course,
  ) {
    final player1Scores = _simulatePlayerRounds(player1, course);
    final player2Scores = _simulatePlayerRounds(player2, course);

    int player1Wins = 0;
    int player2Wins = 0;
    double totalScoreDifference = 0;

    for (int i = 0; i < _simulationRounds; i++) {
      final score1 = player1Scores[i];
      final score2 = player2Scores[i];

      if (score1 < score2) {
        player1Wins++;
      } else if (score2 < score1) {
        player2Wins++;
      }

      totalScoreDifference += (score1 - score2).abs();
    }

    final player1WinPercentage = (player1Wins / _simulationRounds) * 100;
    final player2WinPercentage = (player2Wins / _simulationRounds) * 100;
    final averageScoreDifferential = totalScoreDifference / _simulationRounds;

    return HeadToHeadResult(
      player1: player1,
      player2: player2,
      player1WinPercentage: player1WinPercentage,
      player2WinPercentage: player2WinPercentage,
      averageScoreDifferential: averageScoreDifferential,
    );
  }
}
