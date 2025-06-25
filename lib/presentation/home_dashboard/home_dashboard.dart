import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/next_round_card_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/recent_scores_widget.dart';
import './widgets/social_activity_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentIndex = 0;
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

  final Map<String, dynamic> nextRound = {
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
  };

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
    {
      "id": 2,
      "courseName": "St. Andrews Links",
      "date": "March 12, 2024",
      "score": 82,
      "par": 72,
      "format": "Match Play",
      "courseImage":
          "https://images.unsplash.com/photo-1593111774240-d529f12cf4bb?w=400&h=200&fit=crop"
    },
    {
      "id": 3,
      "courseName": "Torrey Pines",
      "date": "March 8, 2024",
      "score": 76,
      "par": 72,
      "format": "Stableford",
      "courseImage":
          "https://images.unsplash.com/photo-1587174486073-ae5e5cec4cce?w=400&h=200&fit=crop"
    }
  ];

  final List<Map<String, dynamic>> socialActivity = [
    {
      "id": 1,
      "type": "score",
      "userName": "Mike Chen",
      "userAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "content": "Shot a personal best 74 at Spyglass Hill!",
      "timestamp": "2 hours ago",
      "likes": 12,
      "comments": 3,
      "isLiked": false
    },
    {
      "id": 2,
      "type": "achievement",
      "userName": "Sarah Wilson",
      "userAvatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "content": "First eagle on hole 15 at Monterey Peninsula!",
      "timestamp": "5 hours ago",
      "likes": 18,
      "comments": 7,
      "isLiked": true
    },
    {
      "id": 3,
      "type": "tournament",
      "userName": "Tom Rodriguez",
      "userAvatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      "content": "Won the monthly club championship with a 2-stroke lead!",
      "timestamp": "1 day ago",
      "likes": 25,
      "comments": 12,
      "isLiked": true
    }
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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/schedule-round');
        break;
      case 2:
        Navigator.pushNamed(context, '/live-scoring');
        break;
      case 3:
        Navigator.pushNamed(context, '/leaderboard');
        break;
      case 4:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  void _createNewRound() {
    Navigator.pushNamed(context, '/schedule-round');
  }

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
                    // Greeting Header
                    GreetingHeaderWidget(
                      userName: userData["name"] as String,
                      location: userData["location"] as String,
                      weather: userData["weather"] as String,
                    ),

                    SizedBox(height: 2.h),

                    // Next Round Card
                    NextRoundCardWidget(
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

                    SizedBox(height: 3.h),

                    // Quick Stats
                    QuickStatsWidget(
                      handicap: userData["handicap"] as double,
                      recentAverage: userData["recentAverage"] as double,
                      improvementTrend: userData["improvementTrend"] as String,
                      onTap: () {
                        // Navigate to detailed analytics
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Recent Scores Section
                    RecentScoresWidget(
                      scores: recentScores,
                      onScoreCardTap: (scoreData) {
                        // Navigate to score details
                      },
                      onScoreCardLongPress: (scoreData) {
                        _showScoreContextMenu(scoreData);
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Social Activity Feed
                    SocialActivityWidget(
                      activities: socialActivity,
                      onLike: (activityId) {
                        _handleLike(activityId);
                      },
                      onComment: (activityId) {
                        _handleComment(activityId);
                      },
                    ),

                    SizedBox(height: 10.h), // Bottom padding for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewRound,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        elevation: 8.0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor!
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor!,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'schedule',
              color: _currentIndex == 1
                  ? Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor!
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor!,
              size: 24,
            ),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'sports_golf',
              color: _currentIndex == 2
                  ? Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor!
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor!,
              size: 24,
            ),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'leaderboard',
              color: _currentIndex == 3
                  ? Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor!
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor!,
              size: 24,
            ),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 4
                  ? Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor!
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor!,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showScoreContextMenu(Map<String, dynamic> scoreData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: Theme.of(context).bottomSheetTheme.shape,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'View Details',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to score details
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'Share Score',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Share score
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'emoji_events',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'Add to Tournament',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Add to tournament
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleLike(int activityId) {
    setState(() {
      final activityIndex =
          socialActivity.indexWhere((activity) => activity["id"] == activityId);
      if (activityIndex != -1) {
        final activity = socialActivity[activityIndex];
        final isLiked = activity["isLiked"] as bool;
        activity["isLiked"] = !isLiked;
        activity["likes"] = (activity["likes"] as int) + (isLiked ? -1 : 1);
      }
    });
  }

  void _handleComment(int activityId) {
    // Navigate to comments or show comment dialog
  }
}
