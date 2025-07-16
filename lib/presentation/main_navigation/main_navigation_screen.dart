import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/error_boundary_widget.dart';
import '../../widgets/persistent_bottom_nav_widget.dart';
import '../home_dashboard/home_dashboard.dart';
import '../leaderboard/leaderboard.dart';
import '../live_scoring/live_scoring.dart';
import '../schedule_tab/schedule_tab.dart';
import '../user_profile/user_profile.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  final Map<String, dynamic>? arguments;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
    this.arguments,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  late int _currentIndex;
  late PageController _pageController;
  late AnimationController _animationController;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onTabTapped(int index) async {
    if (_isAnimating || index == _currentIndex) return;

    setState(() {
      _isAnimating = true;
    });

    // Haptic feedback
    try {
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }

    // Animate to new page
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );

    setState(() {
      _currentIndex = index;
      _isAnimating = false;
    });
  }

  void _onPageChanged(int index) {
    if (!_isAnimating) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  List<Widget> get _screens => [
        ErrorBoundaryWidget(
          child: const HomeDashboard(),
        ),
        ErrorBoundaryWidget(
          child: const ScheduleTab(),
        ),
        ErrorBoundaryWidget(
          child: LiveScoring(roundData: widget.arguments),
        ),
        ErrorBoundaryWidget(
          child: const Leaderboard(),
        ),
        ErrorBoundaryWidget(
          child: const UserProfile(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics:
            const NeverScrollableScrollPhysics(), // Good - prevents accidental swipes
        children: _screens,
      ),
      bottomNavigationBar: PersistentBottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// Wrapper for HomeDashboard content without bottom navigation
class HomeDashboardContent extends StatefulWidget {
  const HomeDashboardContent({super.key});

  @override
  State<HomeDashboardContent> createState() => _HomeDashboardContentState();
}

class _HomeDashboardContentState extends State<HomeDashboardContent> {
  bool _isRefreshing = false;

  // Mock data for the dashboard
  final Map<String, dynamic> userData = {
    "name": "Alex Johnson",
    "handicap": 12.4,
    "recentAverage": 84.2,
    "improvementTrend": "+2.1",
    "location": "San Francisco, CA",
    "weather": "Sunny, 72°F"
  };

  // Updated to support multiple upcoming rounds
  final List<Map<String, dynamic>> upcomingRounds = [
    {
      "id": 1,
      "courseName": "Pebble Beach Golf Links",
      "date": "Tomorrow",
      "time": "8:30 AM",
      "invitedFriends": [
        {
          "name": "Mike Chen",
          "avatar":
              "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face"
        },
        {
          "name": "Sarah Wilson",
          "avatar":
              "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face"
        },
        {
          "name": "Tom Rodriguez",
          "avatar":
              "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face"
        }
      ]
    },
// ... keep existing rounds data ...
  ];

  final List<Map<String, dynamic>> recentScores = [
    {
      "id": 1,
      "courseName": "Augusta National",
      "date": "March 15, 2024",
      "score": 78,
      "par": 72,
      "format": "Stroke Play",
      "courseImage":
          "https://images.unsplash.com/photo-1535131749006-b7f58c99034b?w=400&h=200&fit=crop"
    },
// ... keep existing scores data ...
  ];

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _createNewRound() {
    Navigator.pushNamed(context, AppRoutes.scheduleRound);
  }

  // ... keep existing handler methods ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Theme.of(context).colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ... keep existing content structure ...
                    SizedBox(
                        height:
                            2.h), // Reduced bottom padding since no FAB overlap
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewRound,
        backgroundColor: AppTheme.accentGreen,
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Theme.of(context).colorScheme.onTertiary,
          size: 24,
        ),
        label: Text(
          'New Round',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
        ),
      ),
    );
  }

  // ... keep existing helper methods ...
}
