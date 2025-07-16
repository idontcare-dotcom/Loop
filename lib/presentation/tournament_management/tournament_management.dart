import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/create_tournament_widget.dart';
import './widgets/discover_tournaments_widget.dart';
import './widgets/joined_tournaments_widget.dart';
import './widgets/my_tournaments_widget.dart';
import './widgets/tournament_header_widget.dart';
import './widgets/tournament_segmented_control_widget.dart';

class TournamentManagement extends StatefulWidget {
  const TournamentManagement({super.key});

  @override
  State<TournamentManagement> createState() => _TournamentManagementState();
}

class _TournamentManagementState extends State<TournamentManagement>
    with TickerProviderStateMixin {
  int _currentIndex = 1; // Set to tournaments tab
  int _selectedSegment = 0; // 0: My Tournaments, 1: Joined, 2: Discover
  bool _isLoading = false;
  bool _showCreateTournament = false;

  late TabController _tabController;

  // Mock tournament data
  final List<Map<String, dynamic>> myTournaments = [
    {
      "id": 1,
      "name": "Spring Classic Championship",
      "format": "Stroke Play",
      "startDate": "2024-04-15",
      "endDate": "2024-04-16",
      "course": "Pebble Beach Golf Links",
      "participants": 24,
      "maxParticipants": 32,
      "entryFee": 150.0,
      "status": "Open",
      "isOrganizer": true,
      "image":
          "https://images.unsplash.com/photo-1535131749006-b7f58c99034b?w=400&h=200&fit=crop"
    },
    {
      "id": 2,
      "name": "Monthly Stroke Play",
      "format": "Stroke Play",
      "startDate": "2024-04-22",
      "endDate": "2024-04-22",
      "course": "Augusta National",
      "participants": 18,
      "maxParticipants": 24,
      "entryFee": 75.0,
      "status": "Open",
      "isOrganizer": true,
      "image":
          "https://images.unsplash.com/photo-1593111774240-d529f12cf4bb?w=400&h=200&fit=crop"
    }
  ];

  final List<Map<String, dynamic>> joinedTournaments = [
    {
      "id": 3,
      "name": "Pro-Am Challenge",
      "format": "Team Play",
      "startDate": "2024-04-20",
      "endDate": "2024-04-21",
      "course": "St. Andrews Links",
      "participants": 48,
      "maxParticipants": 64,
      "entryFee": 200.0,
      "status": "Open",
      "isOrganizer": false,
      "image":
          "https://images.unsplash.com/photo-1587174486073-ae5e5cec4cce?w=400&h=200&fit=crop"
    }
  ];

  final List<Map<String, dynamic>> discoverTournaments = [
    {
      "id": 4,
      "name": "Open Championship Qualifier",
      "format": "Match Play",
      "startDate": "2024-05-01",
      "endDate": "2024-05-03",
      "course": "Torrey Pines",
      "participants": 32,
      "maxParticipants": 64,
      "entryFee": 300.0,
      "status": "Open",
      "isOrganizer": false,
      "image":
          "https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=400&h=200&fit=crop"
    },
    {
      "id": 5,
      "name": "Charity Golf Classic",
      "format": "Scramble",
      "startDate": "2024-05-10",
      "endDate": "2024-05-10",
      "course": "Spyglass Hill",
      "participants": 16,
      "maxParticipants": 40,
      "entryFee": 100.0,
      "status": "Open",
      "isOrganizer": false,
      "image":
          "https://images.unsplash.com/photo-1606390758976-78dcfcc60f80?w=400&h=200&fit=crop"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedSegment = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        // Already on tournaments
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.liveScoring);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.leaderboard);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.userProfile);
        break;
    }
  }

  void _toggleCreateTournament() {
    setState(() {
      _showCreateTournament = true;
    });
  }

  void _hideCreateTournament() {
    setState(() {
      _showCreateTournament = false;
    });
  }

  Future<void> _handleCreateTournament(
      Map<String, dynamic> tournamentData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Mock tournament creation delay
      await Future.delayed(const Duration(seconds: 2));

      // Add to my tournaments list
      final newTournament = {
        "id": myTournaments.length + 1,
        "name": tournamentData["name"],
        "format": tournamentData["format"],
        "startDate": tournamentData["startDate"],
        "endDate": tournamentData["endDate"],
        "course": tournamentData["course"],
        "participants": 1,
        "maxParticipants": tournamentData["maxParticipants"],
        "entryFee": tournamentData["entryFee"],
        "status": "Open",
        "isOrganizer": true,
        "image":
            "https://images.unsplash.com/photo-1535131749006-b7f58c99034b?w=400&h=200&fit=crop"
      };

      setState(() {
        myTournaments.insert(0, newTournament);
        _selectedSegment = 0; // Switch to My Tournaments
        _tabController.animateTo(0);
      });

      _hideCreateTournament();

      Fluttertoast.showToast(
        msg: "Tournament created successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to create tournament. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleJoinTournament(Map<String, dynamic> tournament) {
    setState(() {
      tournament["participants"] = tournament["participants"] + 1;
      joinedTournaments.insert(0, tournament);
      discoverTournaments.remove(tournament);
    });

    Fluttertoast.showToast(
      msg: "Joined ${tournament["name"]} successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    Fluttertoast.showToast(
      msg: "Tournaments refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                const TournamentHeaderWidget(),
                SizedBox(height: 2.h),

                // Segmented Control
                TournamentSegmentedControlWidget(
                  controller: _tabController,
                  onTabChanged: (index) {
                    setState(() {
                      _selectedSegment = index;
                    });
                  },
                ),
                SizedBox(height: 1.h),

                // Content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    color: Theme.of(context).colorScheme.primary,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        MyTournamentsWidget(
                          tournaments: myTournaments,
                          isLoading: _isLoading,
                          onTournamentTap: (tournament) {
                            // Navigate to tournament details
                          },
                          onEditTournament: (tournament) {
                            // Edit tournament
                          },
                          onCancelTournament: (tournament) {
                            // Cancel tournament
                          },
                        ),
                        JoinedTournamentsWidget(
                          tournaments: joinedTournaments,
                          isLoading: _isLoading,
                          onTournamentTap: (tournament) {
                            // Navigate to tournament details
                          },
                          onLeaveTournament: (tournament) {
                            setState(() {
                              joinedTournaments.remove(tournament);
                              tournament["participants"] =
                                  tournament["participants"] - 1;
                              discoverTournaments.insert(0, tournament);
                            });
                          },
                        ),
                        DiscoverTournamentsWidget(
                          tournaments: discoverTournaments,
                          isLoading: _isLoading,
                          onTournamentTap: (tournament) {
                            // Navigate to tournament details
                          },
                          onJoinTournament: _handleJoinTournament,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Create Tournament Modal
            if (_showCreateTournament)
              CreateTournamentWidget(
                onClose: _hideCreateTournament,
                onCreateTournament: _handleCreateTournament,
                isLoading: _isLoading,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleCreateTournament,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Theme.of(context).colorScheme.onTertiary,
          size: 24,
        ),
        label: Text(
          'Create Tournament',
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
              iconName: 'emoji_events',
              color: _currentIndex == 1
                  ? Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor!
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor!,
              size: 24,
            ),
            label: 'Tournaments',
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
}
