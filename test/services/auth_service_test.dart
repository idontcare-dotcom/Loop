import 'package:flutter_test/flutter_test.dart';
import 'package:loop_golf/config/app_config.dart';
import 'package:loop_golf/services/auth_service.dart';

void main() {
  setUpAll(() async {
    await AppConfig.load();
  });

  test('initialize prints using config values', () async {
    final service = AuthService();
    expect(
      () => service.initialize(),
      prints(contains(AppConfig.instance.supabaseUrl)),
    );
  });
}
