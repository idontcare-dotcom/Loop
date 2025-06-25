import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:loop_golf/config/app_config.dart';
import 'package:loop_golf/services/database_service.dart';
import 'package:loop_golf/models/round.dart';
import 'package:loop_golf/models/score.dart';
import 'package:loop_golf/models/player.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late DatabaseService service;

  setUpAll(() async {
    await AppConfig.load();
  });

  setUp(() {
    dio = MockDio();
    service = DatabaseService(baseUrl: 'https://example.com', anonKey: 'key', dio: dio);
  });

  test('fetchRounds returns list of rounds', () async {
    when(() => dio.get('rounds')).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: 'rounds'),
          data: [
            {'id': 1, 'courseName': 'Test Course', 'date': '2024-01-01'},
          ],
          statusCode: 200,
        ));

    final rounds = await service.fetchRounds();

    expect(rounds, isA<List<Round>>());
    expect(rounds.first.id, 1);
  });

  test('fetchScores returns list of scores', () async {
    when(() => dio.get('scores')).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: 'scores'),
          data: [
            {
              'id': 1,
              'courseName': 'Test Course',
              'date': '2024-01-01',
              'score': 70,
              'par': 72,
              'format': 'stroke',
              'courseImage': 'img.png'
            },
          ],
          statusCode: 200,
        ));

    final scores = await service.fetchScores();

    expect(scores, isA<List<Score>>());
    expect(scores.first.id, 1);
  });

  test('fetchLeaderboard returns list of players', () async {
    when(() => dio.get('leaderboard')).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: 'leaderboard'),
          data: [
            {'id': 1, 'name': 'Player', 'avatar': 'img.png'},
          ],
          statusCode: 200,
        ));

    final players = await service.fetchLeaderboard();

    expect(players, isA<List<Player>>());
    expect(players.first.id, 1);
  });

  test('addScore posts score data', () async {
    final score = Score(
      id: 1,
      courseName: 'Test Course',
      date: DateTime.parse('2024-01-01'),
      score: 70,
      par: 72,
      format: 'stroke',
      courseImage: 'img.png',
    );

    when(() => dio.post('scores', data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'scores'),
        statusCode: 201,
      ),
    );

    await service.addScore(score);

    verify(() => dio.post('scores', data: jsonEncode(score.toJson()))).called(1);
  });

  test('addRound posts round data', () async {
    final round = Round(
      id: 1,
      courseName: 'Test Course',
      date: DateTime.parse('2024-01-01'),
    );

    when(() => dio.post('rounds', data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'rounds'),
        statusCode: 201,
      ),
    );

    await service.addRound(round);

    verify(() => dio.post('rounds', data: jsonEncode(round.toJson()))).called(1);
  });
}
