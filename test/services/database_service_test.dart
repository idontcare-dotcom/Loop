import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:loop_golf/services/database_service.dart';
import 'package:loop_golf/models/round.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late DatabaseService service;

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
}
