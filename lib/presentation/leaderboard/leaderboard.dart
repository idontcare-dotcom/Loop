import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_options_widget.dart';
import './widgets/leaderboard_header_widget.dart';
import './widgets/player_row_widget.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  bool _isRefreshing = false;
  String _selectedFilter = 'gross';
  final String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Mock data for leaderboard
  final List<Map<String, dynamic>> _currentRoundData = [
    {
      "id": 1,
      "position": 1,
      "name": "Michael Rodriguez",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "currentScore": -3,
      "holesCompleted": 18,
      "totalStrokes": 69,
      "scoreToPar": -3,
      "holeByHole": [4, 3, 5, 4, 3, 4, 5, 3, 4, 4, 3, 5, 4, 3, 4, 5, 3, 4],
      "isLive": true,
      "lastUpdated": "2 min ago"
    },
    {
      "id": 2,
      "position": 2,
      "name": "Sarah Johnson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "currentScore": -2,
      "holesCompleted": 17,
      "totalStrokes": 70,
      "scoreToPar": -2,
      "holeByHole": [4, 4, 5, 3, 3, 4, 5, 4, 4, 4, 3, 5, 4, 3, 4, 5],
      "isLive": true,
      "lastUpdated": "1 min ago"
    },
    {
      "id": 3,
      "position": 3,
      "name": "David Chen",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "currentScore": -1,
      "holesCompleted": 16,
      "totalStrokes": 71,
      "scoreToPar": -1,
      "holeByHole": [5, 3, 5, 4, 4, 4, 5, 3, 4, 4, 3, 5, 4, 3, 4, 5],
      "isLive": true,
      "lastUpdated": "3 min ago"
    },
    {
      "id": 4,
      "position": 4,
      "name": "Emma Wilson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "currentScore": 0,
      "holesCompleted": 18,
      "totalStrokes": 72,
      "scoreToPar": 0,
      "holeByHole": [4, 4, 5, 4, 3, 4, 5, 3, 4, 4, 3, 5, 4, 4, 4, 5, 3, 4],
      "isLive": false,
      "lastUpdated": "5 min ago"
    },
    {
      "id": 5,
      "position": 5,
      "name": "James Thompson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "currentScore": 1,
      "holesCompleted": 15,
      "totalStrokes": 73,
      "scoreToPar": 1,
      "holeByHole": [4, 4, 6, 4, 3, 4, 5, 4, 4, 4, 3, 5, 4, 4, 4],
      "isLive": true,
      "lastUpdated": "4 min ago"
    },
  ];

  final List<Map<String, dynamic>> _tournamentData = [
    {
      "id": 1,
      "position": 1,
      "name": "Michael Rodriguez",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "totalScore": -8,
      "roundsPlayed": 3,
      "totalStrokes": 208,
      "scoreToPar": -8,
      "rounds": [69, 70, 69],
      "trend": "up"
    },
    {
      "id": 2,
      "position": 2,
      "name": "Sarah Johnson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "totalScore": -6,
      "roundsPlayed": 3,
      "totalStrokes": 210,
      "scoreToPar": -6,
      "rounds": [71, 69, 70],
      "trend": "stable"
    },
    {
      "id": 3,
      "position": 3,
      "name": "David Chen",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "totalScore": -4,
      "roundsPlayed": 3,
      "totalStrokes": 212,
      "scoreToPar": -4,
      "rounds": [70, 71, 71],
      "trend": "down"
    },
  ];

  final List<Map<String, dynamic>> _friendsData = [
    {
      "id": 1,
      "position": 1,
      "name": "Alex Parker",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "currentScore": -2,
      "holesCompleted": 18,
      "totalStrokes": 70,
      "scoreToPar": -2,
      "isFriend": true,
      "status": "online"
    },
    {
      "id": 2,
      "position": 2,
      "name": "Lisa Martinez",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "currentScore": 1,
      "holesCompleted": 16,
      "totalStrokes": 73,
      "scoreToPar": 1,
      "isFriend": true,
      "status": "playing"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _currentData {
    List<Map<String, dynamic>> data;
    switch (_currentTabIndex) {
      case 0:
        data = _currentRoundData;
        break;
      case 1:
        data = _tournamentData;
        break;
      case 2:
        data = _friendsData;
        break;
      default:
        data = _currentRoundData;
    }

    if (_searchQuery.isNotEmpty) {
      data = data
          .where((player) => (player['name'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return data;
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showPlayerDetails(Map<String, dynamic> player) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomImageWidget(
                          imageUrl: player['avatar'] as String,
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player['name'] as String,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                'Position: #${player['position']}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    if (player['holeByHole'] != null) ...[
                      Text(
                        'Hole-by-Hole Scorecard',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 2.h),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          childAspectRatio: 1,
                          crossAxisSpacing: 2.w,
                          mainAxisSpacing: 1.h,
                        ),
                        itemCount: (player['holeByHole'] as List).length,
                        itemBuilder: (context, index) {
                          final score = (player['holeByHole'] as List)[index];
                          final par = 4; // Assuming par 4 for simplicity
                          Color scoreColor =
                              Theme.of(context).textTheme.bodyMedium!.color!;
                          if (score < par) {
                            scoreColor = AppTheme.successLight;
                          } else if (score > par) {
                            scoreColor = AppTheme.errorLight;
                          }

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontSize: 8.sp),
                                ),
                                Text(
                                  score.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: scoreColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlayerContextMenu(Map<String, dynamic> player) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/user-profile');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              title: const Text('Message Player'),
              onTap: () {
                Navigator.pop(context);
                // Handle message functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'compare_arrows',
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              title: const Text('Compare Scores'),
              onTap: () {
                Navigator.pop(context);
                // Handle compare scores functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'search',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PlayerSearchDelegate(_currentData),
              );
            },
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            onPressed: () {
              // Handle share functionality
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Current Round'),
            Tab(text: 'Tournament'),
            Tab(text: 'Friends'),
          ],
        ),
      ),
      body: Column(
        children: [
          LeaderboardHeaderWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          FilterOptionsWidget(
            currentTab: _currentTabIndex,
            onFilterApplied: () {
              // Handle filter application
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardList(_currentRoundData),
                _buildLeaderboardList(_tournamentData),
                _buildLeaderboardList(_friendsData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<Map<String, dynamic>> data) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: _isRefreshing
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'emoji_events',
                        color: Theme.of(context).primaryColor,
                        size: 64,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No players yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Be the first to join this tournament!',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(2.w),
                  itemCount: _currentData.length,
                  itemBuilder: (context, index) {
                    final player = _currentData[index];
                    return PlayerRowWidget(
                      player: player,
                      onTap: () => _showPlayerDetails(player),
                      onLongPress: () => _showPlayerContextMenu(player),
                    );
                  },
                ),
    );
  }
}

class PlayerSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> players;

  PlayerSearchDelegate(this.players);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: CustomIconWidget(
          iconName: 'clear',
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: CustomIconWidget(
        iconName: 'arrow_back',
        color: Theme.of(context).primaryColor,
        size: 24,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = players
        .where((player) => (player['name'] as String)
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final player = results[index];
        return PlayerRowWidget(
          player: player,
          onTap: () {
            close(context, player['name'] as String);
          },
          onLongPress: () {},
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = players
        .where((player) => (player['name'] as String)
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final player = suggestions[index];
        return ListTile(
          leading: CustomImageWidget(
            imageUrl: player['avatar'] as String,
            width: 10.w,
            height: 10.w,
            fit: BoxFit.cover,
          ),
          title: Text(player['name'] as String),
          subtitle: Text('Position: #${player['position']}'),
          onTap: () {
            query = player['name'] as String;
            showResults(context);
          },
        );
      },
    );
  }
}
