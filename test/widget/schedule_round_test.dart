import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loop_golf/config/app_config.dart';
import 'package:loop_golf/presentation/schedule_round/schedule_round.dart';
import 'package:sizer/sizer.dart';

Widget _wrap(Widget child) {
  return Sizer(builder: (_, __, ___) {
    return MaterialApp(home: child);
  });
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppConfig.load();
  });

  testWidgets('schedule round screen renders', (tester) async {
    await tester.pumpWidget(_wrap(const ScheduleRound()));
    await tester.pumpAndSettle();

    expect(find.text('Schedule Round'), findsOneWidget);
    expect(find.text('Create Round'), findsOneWidget);
  });
}
