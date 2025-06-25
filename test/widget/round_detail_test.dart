import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loop_golf/config/app_config.dart';
import 'package:loop_golf/presentation/round_detail/round_detail.dart';
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

  testWidgets('round detail screen renders', (tester) async {
    await tester.pumpWidget(_wrap(const RoundDetail(roundId: 1)));
    await tester.pumpAndSettle();

    expect(find.text('Round Detail'), findsOneWidget);
    expect(find.text('Hole Scores'), findsOneWidget);
  });
}
