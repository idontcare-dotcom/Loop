import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/player.dart';
import '../models/round.dart';
import '../models/score.dart';

class DatabaseService {
  final Dio _dio;

  DatabaseService({required String baseUrl, required String anonKey, Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: '${baseUrl}/rest/v1/',
                headers: {
                  'apikey': anonKey,
                  'Authorization': 'Bearer $anonKey',
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

  Future<List<Round>> fetchRounds() async {
    try {
      final response = await _dio.get('rounds');
      final data = response.data as List<dynamic>;
      return data
          .map((e) => Round.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch rounds: ${e.message}');
    }
  }

  Future<List<Score>> fetchScores() async {
    try {
      final response = await _dio.get('scores');
      final data = response.data as List<dynamic>;
      return data
          .map((e) => Score.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch scores: ${e.message}');
    }
  }

  Future<List<Player>> fetchLeaderboard() async {
    try {
      final response = await _dio.get('leaderboard');
      final data = response.data as List<dynamic>;
      return data
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch leaderboard: ${e.message}');
    }
  }

  Future<void> addScore(Score score) async {
    try {
      await _dio.post('scores', data: jsonEncode(score.toJson()));
    } on DioException catch (e) {
      throw Exception('Failed to add score: ${e.message}');
    }
  }

  Future<void> addRound(Round round) async {
    try {
      await _dio.post('rounds', data: jsonEncode(round.toJson()));
    } on DioException catch (e) {
      throw Exception('Failed to add round: ${e.message}');
    }
  }
}
