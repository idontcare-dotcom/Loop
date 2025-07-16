import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/achievement_badges_widget.dart';
import './widgets/friends_management_widget.dart';
import './widgets/handicap_management_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/statistics_cards_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int _currentIndex = 4; // Profile tab active

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Michael Rodriguez",
    "profilePhoto":
        "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    "handicap": 12.4,
    "handicapTrend": "improving", // improving, declining, stable
    "location": "San Diego, CA",
    "roundsPlayed": 48,
    "averageScore": 84.2,
    "bestRound": 78,
    "improvementTrend": "+3.2",
    "achievements": [
      {
        "id": 1,
        "title": "Eagle Achievement",
        "description": "First eagle on par 5",
        "icon": "emoji_events",
        "date": "2024-01-15",
        "unlocked": true
      },
      {
        "id": 2,
        "title": "Consistency King",
        "description": "5 rounds under 85",
        "icon": "trending_up",
        "date": "2024-01-10",
        "unlocked": true
      },
      {
        "id": 3,
        "title": "Social Golfer",
        "description": "Played with 10 friends",
        "icon": "group",
        "date": "2024-01-05",
        "unlocked": false
      }
    ],
    "friends": [
      {
        "id": 1,
        "name": "Sarah Johnson",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "handicap": 18.2,
        "lastPlayed": "2 days ago",
        "mutualFriends": 3
      },
      {
        "id": 2,
        "name": "David Chen",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "handicap": 8.7,
        "lastPlayed": "1 week ago",
        "mutualFriends": 5
      }
    ],
    "linkedAccounts": ["Google", "Apple"],
    "isPremium": false,
    "preferences": {
      "notifications": true,
      "scoreVisibility": "friends",
      "friendDiscovery": true,
      "dataSharing": false,
      "darkMode": false
    }
  };

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home-dashboard');
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
        // Stay on profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ProfileHeaderWidget(userData: userData),
              SizedBox(height: 2.h),
              StatisticsCardsWidget(userData: userData),
              SizedBox(height: 2.h),
              AchievementBadgesWidget(
                achievements: (userData["achievements"] as List)
                    .map((item) => item as Map<String, dynamic>)
                    .toList(),
              ),
              SizedBox(height: 2.h),
              HandicapManagementWidget(userData: userData),
              SizedBox(height: 2.h),
              FriendsManagementWidget(
                friends: (userData["friends"] as List)
                    .map((item) => item as Map<String, dynamic>)
                    .toList(),
              ),
              SizedBox(height: 2.h),
              SettingsSectionWidget(userData: userData),
              SizedBox(height: 2.h), // Reduced bottom padding
            ],
          ),
        ),
      ),
      // Remove bottomNavigationBar completely
    );
  }
}
