import 'package:flutter/material.dart';

import '../presentation/login_screen/login_screen.dart';
import '../presentation/main_navigation/main_navigation_screen.dart';
import '../presentation/odds_calculator/odds_calculator.dart';
import '../presentation/odds_calculator_mobile_preview/odds_calculator_mobile_preview.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/schedule_round/schedule_round.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/tournament_management/tournament_management.dart';

class AppRoutes {
  // Route names
  static const String initial = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String mainNavigation = '/main-navigation';
  static const String scheduleRound = '/schedule-round';
  static const String tournamentManagement = '/tournament-management';
  static const String liveScoring = '/live-scoring';
  static const String oddsCalculator = '/odds-calculator';
  static const String oddsCalculatorMobilePreview =
      '/odds-calculator-mobile-preview';

  // Legacy route constants for compatibility
  static const String userProfile = '/user-profile';
  static const String leaderboard = '/leaderboard';
  static const String scheduleTab = '/schedule-tab';
  static const String homeDashboard = '/home';
  static const String registrationScreen = '/register';
  static const String HOME_DASHBOARD = '/home';
  static const String LOGIN_SCREEN = '/login';

  // Route map
  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegistrationScreen(),
    home: (context) => const MainNavigationScreen(initialIndex: 0),
    mainNavigation: (context) => const MainNavigationScreen(initialIndex: 0),
    userProfile: (context) => const MainNavigationScreen(initialIndex: 4),
    leaderboard: (context) => const MainNavigationScreen(initialIndex: 3),
    scheduleTab: (context) => const MainNavigationScreen(initialIndex: 1),
    scheduleRound: (context) => const ScheduleRound(),
    tournamentManagement: (context) => const TournamentManagement(),
    liveScoring: (context) => const MainNavigationScreen(initialIndex: 2),
    oddsCalculator: (context) => const OddsCalculator(),
    oddsCalculatorMobilePreview: (context) =>
        const OddsCalculatorMobilePreview(),
  };

  // Route generator for dynamic routes
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final WidgetBuilder? builder = routes[settings.name];
    if (builder != null) {
      // Handle ScheduleRound with arguments
      if (settings.name == scheduleRound && settings.arguments != null) {
        final args = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              ScheduleRound(
            preSelectedDate: args['selectedDate'] as DateTime?,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Standard transition effect
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            var offsetAnimation = animation.drive(tween);

            var fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
            ));

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
      }

      // Handle LiveScoring with arguments through MainNavigation
      if (settings.name == liveScoring && settings.arguments != null) {
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              MainNavigationScreen(
            initialIndex: 2,
            arguments: settings.arguments as Map<String, dynamic>?,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Standard transition effect
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            var offsetAnimation = animation.drive(tween);

            var fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
            ));

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
      }

      // Handle navigation with specific tab index
      if (settings.name == userProfile ||
          settings.name == leaderboard ||
          settings.name == scheduleTab ||
          settings.name == home ||
          settings.name == mainNavigation) {
        int initialIndex = 0;
        switch (settings.name) {
          case userProfile:
            initialIndex = 4;
            break;
          case leaderboard:
            initialIndex = 3;
            break;
          case scheduleTab:
            initialIndex = 1;
            break;
          case liveScoring:
            initialIndex = 2;
            break;
          default:
            initialIndex = 0;
        }

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              MainNavigationScreen(
            initialIndex: initialIndex,
            arguments: settings.arguments as Map<String, dynamic>?,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Faster transition for tab switching
            var fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
            ));

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
        );
      }

      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Standard transition effect
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          var offsetAnimation = animation.drive(tween);

          var fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ));

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: offsetAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      );
    }
    return null;
  }
}
