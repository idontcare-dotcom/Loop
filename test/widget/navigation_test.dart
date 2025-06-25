import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loop_golf/main.dart';
import 'package:loop_golf/routes/app_routes.dart';
import 'package:loop_golf/presentation/home_dashboard/home_dashboard.dart';
import 'package:loop_golf/presentation/leaderboard/leaderboard.dart';
import 'package:loop_golf/presentation/live_scoring/live_scoring.dart';
import 'package:loop_golf/presentation/user_profile/user_profile.dart';

void main() {
  testWidgets('home to leaderboard via bottom navigation', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeDashboard), findsOneWidget);

    await tester.tap(find.text('Leaderboard'));
    await tester.pumpAndSettle();

    expect(find.byType(Leaderboard), findsOneWidget);
  });

  testWidgets('leaderboard to profile via bottom navigation', (tester) async {
    await tester.pumpWidget(MaterialApp(
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.leaderboard,
    ));
    await tester.pumpAndSettle();

    expect(find.byType(Leaderboard), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(UserProfile), findsOneWidget);
  });

  testWidgets('live scoring end round navigates to leaderboard', (tester) async {
    await tester.pumpWidget(MaterialApp(
      routes: AppRoutes.routes,
      home: const LiveScoring(),
    ));

    await tester.pumpAndSettle();

    // tap End Round in app bar which opens confirmation dialog
    await tester.tap(find.text('End Round').first);
    await tester.pumpAndSettle();

    // confirm navigation
    await tester.tap(find.text('End Round').last);
    await tester.pumpAndSettle();

    expect(find.byType(Leaderboard), findsOneWidget);
  });
}
