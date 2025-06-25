import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/leaderboard/leaderboard.dart';
import '../presentation/live_scoring/live_scoring.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/schedule_round/schedule_round.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String scheduleRound = '/schedule-round';
  static const String liveScoring = '/live-scoring';
  static const String leaderboard = '/leaderboard';
  static const String userProfile = '/user-profile';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    scheduleRound: (context) => const ScheduleRound(),
    liveScoring: (context) => const LiveScoring(),
    leaderboard: (context) => const Leaderboard(),
    userProfile: (context) => const UserProfile(),
  };
}
