import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/error_boundary_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/recent_scores_widget.dart';
import './widgets/swipeable_next_round_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  bool _isRefreshing = false;
  // Remove unused variable
  // final int _currentIndex = 0;

  // Mock data for the dashboard
  final Map<String, dynamic> userData = {
    "name": "Alex Johnson",
    "handicap": 12.4,
    "recentAverage": 84.2,
    "improvementTrend": "+2.1",
    "location": "San Francisco, CA",
    "weather": "Sunny, 72°F"
  };

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
    {
      "id": 2,
      "courseName": "Augusta National Golf Club",
      "date": "Saturday",
      "time": "2:15 PM",
      "invitedFriends": [
        {
          "name": "David Park",
          "avatar":
              "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face"
        },
        {
          "name": "Lisa Chang",
          "avatar":
              "https://images.unsplash.com/photo-1438761174240-d529f12cf4bb?w=150&h=150&fit=crop&crop=face"
        }
      ]
    },
    {
      "id": 3,
      "courseName": "St. Andrews Old Course",
      "date": "Next Monday",
      "time": "10:00 AM",
      "invitedFriends": [
        {
          "name": "James Smith",
          "avatar":
              "https://images.unsplash.com/photo-1556157382-97eda2d62296?w=150&h=150&fit=crop&crop=face"
        },
        {
          "name": "Emma Taylor",
          "avatar":
              "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face"
        },
        {
          "name": "Ryan Martinez",
          "avatar":
              "https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=150&h=150&fit=crop&crop=face"
        },
        {
          "name": "Alex Thompson",
          "avatar":
              "https://images.unsplash.com/photo-1552058544-f2b08422138a?w=150&h=150&fit=crop&crop=face"
        }
      ]
    }
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

  Future<void> _handleRefresh() async {
    try {
      setState(() {
        _isRefreshing = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    } catch (e) {
      debugPrint('Refresh error: $e');
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  void _createNewRound() {
    try {
      Navigator.pushNamed(context, AppRoutes.scheduleRound);
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
  }

  void _handleRoundTap(Map<String, dynamic> roundData) {
    try {
      debugPrint('Round tapped: ${roundData["courseName"]}');
    } catch (e) {
      debugPrint('Round tap error: $e');
    }
  }

  void _handleMessageGroup(Map<String, dynamic> roundData) {
    try {
      debugPrint('Message group for: ${roundData["courseName"]}');
    } catch (e) {
      debugPrint('Message group error: $e');
    }
  }

  void _handleGetDirections(Map<String, dynamic> roundData) {
    try {
      debugPrint('Get directions to: ${roundData["courseName"]}');
    } catch (e) {
      debugPrint('Get directions error: $e');
    }
  }

  void _handleCancelRound(Map<String, dynamic> roundData) {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cancel Round'),
            content: Text(
                'Are you sure you want to cancel your round at ${roundData["courseName"]}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Keep Round'),
              ),
              TextButton(
                onPressed: () {
                  try {
                    setState(() {
                      upcomingRounds.removeWhere(
                          (round) => round["id"] == roundData["id"]);
                    });
                    Navigator.of(context).pop();
                  } catch (e) {
                    debugPrint('Cancel round error: $e');
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Cancel Round'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint('Cancel round dialog error: $e');
    }
  }

  void _showScoreContextMenu(Map<String, dynamic> scoreData) {
    try {
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
        shape: Theme.of(context).bottomSheetTheme.shape,
        isScrollControlled: true,
        builder: (context) => Container(
          constraints: BoxConstraints(
            maxHeight: 50.h,
          ),
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
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('Score context menu error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Theme.of(context).colorScheme.primary,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting Header
                        ErrorBoundaryWidget(
                          child: GreetingHeaderWidget(
                            userName: userData["name"] as String? ?? "User",
                            location: userData["location"] as String? ??
                                "Unknown Location",
                            weather: userData["weather"] as String? ??
                                "Weather Unavailable",
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Swipeable Next Round Cards
                        ErrorBoundaryWidget(
                          child: SwipeableNextRoundWidget(
                            upcomingRounds: upcomingRounds,
                            onRoundTap: _handleRoundTap,
                            onMessageGroup: _handleMessageGroup,
                            onGetDirections: _handleGetDirections,
                            onCancelRound: _handleCancelRound,
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Quick Stats
                        ErrorBoundaryWidget(
                          child: QuickStatsWidget(
                            handicap: userData["handicap"] as double? ?? 0.0,
                            recentAverage:
                                userData["recentAverage"] as double? ?? 0.0,
                            improvementTrend:
                                userData["improvementTrend"] as String? ??
                                    "0.0",
                            onTap: () {},
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Recent Scores Section
                        ErrorBoundaryWidget(
                          child: RecentScoresWidget(
                            scores: recentScores,
                            onScoreCardTap: (scoreData) {},
                            onScoreCardLongPress: (scoreData) {
                              _showScoreContextMenu(scoreData);
                            },
                          ),
                        ),

                        SizedBox(height: 12.h), // Bottom padding for FAB
                      ],
                    ),
                  ),
                ],
              );
            },
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
}
