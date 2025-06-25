import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';

/// Simple placeholder for sending friend invites.
class FriendInviteService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: AppConfig.instance.supabaseUrl),
  );

  /// Sends invites to the given [friends] for a round described by [roundData].
  ///
  /// Returns `true` when the request succeeds, otherwise `false`.
  Future<bool> sendInvites(
    List<Map<String, dynamic>> friends,
    Map<String, dynamic> roundData,
  ) async {
    try {
      final response = await _dio.post(
        '/invites',
        data: {
          'friends': friends,
          'round': roundData,
        },
      );
      final success = response.statusCode == 200 || response.statusCode == 201;
      if (!success) {
        debugPrint('Invite request failed with status: ${response.statusCode}');
      }
      return success;
    } catch (e) {
      debugPrint('Failed to send invites: $e');
      return false;
    }
  }
}
