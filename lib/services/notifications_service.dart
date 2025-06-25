import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';

/// Simple placeholder for sending push notifications.
class NotificationsService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: AppConfig.instance.supabaseUrl),
  );

  /// Sends a push notification with the given [message].
  ///
  /// Returns `true` when the request succeeds, otherwise `false`.
  Future<bool> sendPushNotification(String message) async {
    try {
      final response = await _dio.post(
        '/notifications',
        data: {
          'message': message,
        },
      );
      final success = response.statusCode == 200 || response.statusCode == 201;
      if (!success) {
        debugPrint(
            'Notification request failed with status: ${response.statusCode}');
      }
      return success;
    } catch (e) {
      debugPrint('Failed to send push notification: $e');
      return false;
    }
  }
}
