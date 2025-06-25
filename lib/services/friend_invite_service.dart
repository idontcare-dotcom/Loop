import 'package:flutter/foundation.dart';

/// Simple placeholder for sending friend invites.
class FriendInviteService {
  /// Sends invites to the given [friends] for a round described by [roundData].
  Future<void> sendInvites(List<Map<String, dynamic>> friends, Map<String, dynamic> roundData) async {
    // TODO: Implement invite sending logic
    debugPrint('Inviting ${friends.length} friends');
  }
}
