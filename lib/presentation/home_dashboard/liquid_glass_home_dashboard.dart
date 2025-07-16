import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/liquid_glass_theme.dart';
import './widgets/liquid_glass_bottom_nav_widget.dart';
import './widgets/liquid_glass_greeting_widget.dart';
import './widgets/liquid_glass_next_round_widget.dart';
import './widgets/liquid_glass_stats_widget.dart';

class LiquidGlassHomeDashboard extends StatefulWidget {
  const LiquidGlassHomeDashboard({super.key});

  @override
  State<LiquidGlassHomeDashboard> createState() =>
      _LiquidGlassHomeDashboardState();
}

class _LiquidGlassHomeDashboardState extends State<LiquidGlassHomeDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRefreshing = false;
  late AnimationController _floatingButtonController;
  late Animation<double> _floatingButtonAnimation;

  // Mock data for the dashboard
  final Map<String, dynamic> userData = {
    "name": "Alex Johnson",
    "handicap": 12.4,
    "recentAverage": 84.2,
    "improvementTrend": "+2.1",
    "location": "San Francisco, CA",
    "weather": "Sunny, 72°F"
  };

  final Map<String, dynamic> nextRound = {
    "id": 1,
    "courseName": "Pebble Beach Golf Links",
    "date": "Tomorrow",
    "time": "8:30 AM",
    "invitedFriends": [
      {
        "name": "Mike Chen",
        "avatar":
            "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?w=150&h=150&fit=crop&crop=face"
      },
      {
        "name": "Sarah Wilson",
        "avatar":
            "https://images.pixabay.com/photo/2494790108755-2616b612b786/woman-smiling-portrait.jpg?w=150&h=150&fit=crop&crop=face"
      },
      {
        "name": "Tom Rodriguez",
        "avatar":
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face"
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _floatingButtonController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _floatingButtonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingButtonController,
      curve: Curves.elasticOut,
    ));

    _floatingButtonController.forward();
  }

  @override
  void dispose() {
    _floatingButtonController.dispose();
    super.dispose();
  }

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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.scheduleRound);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.liveScoring);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.leaderboard);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.userProfile);
        break;
    }
  }

  void _createNewRound() {
    Navigator.pushNamed(context, AppRoutes.scheduleRound);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF8F9FA),
              AppTheme.primaryBackground.withAlpha(13), // Use #2F3130
              LiquidGlassTheme.glassSecondary.withAlpha(8),
              const Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppTheme.primaryBackground, // Use #2F3130
            backgroundColor: LiquidGlassTheme.glassWhite.withAlpha(230),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Header
                      LiquidGlassGreetingWidget(
                        userName: userData["name"] as String,
                        location: userData["location"] as String,
                        weather: userData["weather"] as String,
                      ),

                      SizedBox(height: 2.h),

                      // Next Round Card
                      LiquidGlassMotionWidget(
                        delay: const Duration(milliseconds: 200),
                        child: LiquidGlassNextRoundWidget(
                          roundData: nextRound,
                          onTap: () {
                            // Navigate to round details
                          },
                          onMessageGroup: () {
                            // Open group chat
                          },
                          onGetDirections: () {
                            // Open maps
                          },
                          onCancelRound: () {
                            // Cancel round
                          },
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Quick Stats
                      LiquidGlassMotionWidget(
                        delay: const Duration(milliseconds: 400),
                        child: LiquidGlassStatsWidget(
                          handicap: userData["handicap"] as double,
                          recentAverage: userData["recentAverage"] as double,
                          improvementTrend:
                              userData["improvementTrend"] as String,
                          onTap: () {
                            // Navigate to detailed analytics
                          },
                        ),
                      ),

                      SizedBox(height: 15.h), // Bottom padding for bottom nav
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _floatingButtonAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _floatingButtonAnimation.value,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              child: LiquidGlassTheme.motionBlur(
                intensity: 4.0,
                child: GlassButtonWidget(
                  onPressed: _createNewRound,
                  isPrimary: true,
                  backgroundColor:
                      AppTheme.accentGreen, // Use #31C177 for Book New Round
                  borderRadius: 24.0,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              LiquidGlassTheme.glassWhite.withAlpha(102),
                              LiquidGlassTheme.glassWhite.withAlpha(51),
                            ],
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'add',
                          color: LiquidGlassTheme.glassWhite,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'New Round',
                        style: LiquidGlassTheme.glassTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: LiquidGlassTheme.glassWhite,
                          isOnGlass: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: LiquidGlassBottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

/// Widget that adds motion and entrance animations
class LiquidGlassMotionWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const LiquidGlassMotionWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<LiquidGlassMotionWidget> createState() =>
      _LiquidGlassMotionWidgetState();
}

class _LiquidGlassMotionWidgetState extends State<LiquidGlassMotionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}
