import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/player.dart';
import '../models/round.dart';
import '../models/score.dart';

class DatabaseService {
  final Dio _dio;

  DatabaseService({required String baseUrl, required String anonKey})
      : _dio = Dio(
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
    final response = await _dio.get('rounds');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => Round.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Score>> fetchScores() async {
    final response = await _dio.get('scores');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => Score.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Player>> fetchLeaderboard() async {
    final response = await _dio.get('leaderboard');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => Player.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addScore(Score score) async {
    await _dio.post('scores', data: jsonEncode(score.toJson()));
  }

  Future<void> addRound(Round round) async {
    await _dio.post('rounds', data: jsonEncode(round.toJson()));
  }
}
