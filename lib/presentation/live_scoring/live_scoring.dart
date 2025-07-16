import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/hole_detail_modal_widget.dart';
import './widgets/hole_info_widget.dart';
import './widgets/leaderboard_sheet_widget.dart';
import './widgets/optimized_mini_scorecard_widget.dart';
import './widgets/optimized_score_entry_widget.dart';

class LiveScoring extends StatefulWidget {
  final Map<String, dynamic>? roundData;

  const LiveScoring({super.key, this.roundData});

  @override
  State<LiveScoring> createState() => _LiveScoringState();
}

class _LiveScoringState extends State<LiveScoring>
    with TickerProviderStateMixin {
  int currentHole = 1;
  Map<int, int> scores = {};
  bool isLeaderboardVisible = false;
  late AnimationController _animationController;
  late AnimationController _pageTransitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String courseName = '';
  String roundFormat = '';
  List<Map<String, dynamic>> roundPlayers = [];

  final List<Map<String, dynamic>> holeData = [
    {"hole": 1, "par": 4, "yardage": 385, "distanceToPin": 142},
    {"hole": 2, "par": 3, "yardage": 165, "distanceToPin": 98},
    {"hole": 3, "par": 5, "yardage": 520, "distanceToPin": 234},
    {"hole": 4, "par": 4, "yardage": 410, "distanceToPin": 156},
    {"hole": 5, "par": 3, "yardage": 180, "distanceToPin": 87},
    {"hole": 6, "par": 4, "yardage": 395, "distanceToPin": 178},
    {"hole": 7, "par": 5, "yardage": 545, "distanceToPin": 289},
    {"hole": 8, "par": 4, "yardage": 425, "distanceToPin": 201},
    {"hole": 9, "par": 4, "yardage": 380, "distanceToPin": 134},
    {"hole": 10, "par": 4, "yardage": 400, "distanceToPin": 167},
    {"hole": 11, "par": 3, "yardage": 155, "distanceToPin": 92},
    {"hole": 12, "par": 5, "yardage": 510, "distanceToPin": 245},
    {"hole": 13, "par": 4, "yardage": 375, "distanceToPin": 143},
    {"hole": 14, "par": 4, "yardage": 420, "distanceToPin": 189},
    {"hole": 15, "par": 3, "yardage": 170, "distanceToPin": 101},
    {"hole": 16, "par": 5, "yardage": 535, "distanceToPin": 267},
    {"hole": 17, "par": 4, "yardage": 390, "distanceToPin": 152},
    {"hole": 18, "par": 4, "yardage": 415, "distanceToPin": 178},
  ];

  final List<Map<String, dynamic>> leaderboardData = [
    {
      "name": "John Smith",
      "currentScore": -2,
      "thru": 9,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "isCurrentPlayer": true,
    },
    {
      "name": "Mike Johnson",
      "currentScore": -1,
      "thru": 8,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "isCurrentPlayer": false,
    },
    {
      "name": "David Wilson",
      "currentScore": 0,
      "thru": 9,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "isCurrentPlayer": false,
    },
    {
      "name": "Chris Brown",
      "currentScore": 1,
      "thru": 7,
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "isCurrentPlayer": false,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize round data from arguments with null safety
    if (widget.roundData != null) {
      courseName = widget.roundData!['courseName'] as String? ?? 'Golf Course';
      roundFormat = widget.roundData!['format'] as String? ?? 'Stroke Play';
      roundPlayers =
          List<Map<String, dynamic>>.from(widget.roundData!['players'] ?? []);
    } else {
      // Provide default values when no round data is available
      courseName = 'Golf Course';
      roundFormat = 'Stroke Play';
      roundPlayers = [];
    }

    _initializeAnimations();
  }

  void _initializeAnimations() {
    try {
      _animationController = AnimationController(
        duration:
            AnimationConfig.getScaledDuration(AnimationConfig.mediumDuration),
        vsync: this,
      );

      _pageTransitionController = AnimationController(
        duration:
            AnimationConfig.getScaledDuration(AnimationConfig.fastDuration),
        vsync: this,
      );

      _fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: AnimationConfig.fadeInCurve,
      ));

      _slideAnimation = Tween<Offset>(
        begin: const Offset(0.1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _pageTransitionController,
        curve: AnimationConfig.slideInCurve,
      ));

      _animationController.forward();
      _pageTransitionController.forward();
    } catch (e) {
      debugPrint('Error initializing live scoring animations: $e');
    }
  }

  @override
  void dispose() {
    try {
      _animationController.dispose();
      _pageTransitionController.dispose();
    } catch (e) {
      debugPrint('Error disposing live scoring controllers: $e');
    }
    super.dispose();
  }

  Future<void> _navigateToHole(int hole) async {
    if (hole >= 1 && hole <= 18 && hole != currentHole) {
      try {
        // Slide out animation
        await _pageTransitionController.reverse();

        setState(() {
          currentHole = hole;
        });

        // Haptic feedback with error handling
        try {
          HapticFeedback.lightImpact();
        } catch (e) {
          debugPrint('Haptic feedback error: $e');
        }

        // Slide in animation
        _animationController.reset();
        _pageTransitionController.reset();

        await Future.delayed(AnimationConfig.staggerDelay);
        _animationController.forward();
        _pageTransitionController.forward();
      } catch (e) {
        debugPrint('Error navigating to hole: $e');
        // Fallback: just update the hole without animation
        setState(() {
          currentHole = hole;
        });
      }
    }
  }

  void _updateScore(int hole, int score) {
    try {
      setState(() {
        scores[hole] = score;
      });
      try {
        HapticFeedback.mediumImpact();
      } catch (e) {
        debugPrint('Haptic feedback error: $e');
      }
    } catch (e) {
      debugPrint('Error updating score: $e');
      // Try without haptic feedback as fallback
      setState(() {
        scores[hole] = score;
      });
    }
  }

  void _showLeaderboard() {
    try {
      setState(() {
        isLeaderboardVisible = true;
      });
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => LeaderboardSheetWidget(
          leaderboardData: leaderboardData,
          onClose: () {
            setState(() {
              isLeaderboardVisible = false;
            });
          },
        ),
      );
    } catch (e) {
      debugPrint('Error showing leaderboard: $e');
      setState(() {
        isLeaderboardVisible = false;
      });
    }
  }

  void _showHoleDetailModal(int hole) {
    try {
      showDialog(
        context: context,
        builder: (context) => HoleDetailModalWidget(
          hole: hole,
          par: holeData[hole - 1]["par"] as int? ?? 4,
          currentScore: scores[hole] ?? 0,
          onScoreUpdate: (score) => _updateScore(hole, score),
        ),
      );
    } catch (e) {
      debugPrint('Error showing hole detail modal: $e');
    }
  }

  void _endRound() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          'End Round',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        content: Text(
          'Are you sure you want to end this round? Your scores will be saved.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/leaderboard');
            },
            child: Text(
              'End Round',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentHoleData = holeData[currentHole - 1];

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
            size: 24,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courseName.isNotEmpty ? courseName : 'Live Scoring',
              style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
            ),
            if (roundFormat.isNotEmpty)
              Text(
                roundFormat,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color:
                      AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _showLeaderboard,
            child: Text(
              'Leaderboard',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          TextButton(
            onPressed: _endRound,
            child: Text(
              'End Round',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0 && currentHole > 1) {
              _navigateToHole(currentHole - 1);
            } else if (details.primaryVelocity! < 0 && currentHole < 18) {
              _navigateToHole(currentHole + 1);
            }
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          SizedBox(height: 2.h),
                          HoleInfoWidget(
                            hole: currentHole,
                            par: currentHoleData["par"] as int,
                            yardage: currentHoleData["yardage"] as int,
                            distanceToPin:
                                currentHoleData["distanceToPin"] as int,
                          ),
                          SizedBox(height: 4.h),
                          OptimizedScoreEntryWidget(
                            par: currentHoleData["par"] as int,
                            currentScore: scores[currentHole] ?? 0,
                            onScoreChanged: (score) =>
                                _updateScore(currentHole, score),
                          ),
                          SizedBox(height: 4.h),
                          // GPS Distance container with improved responsive design
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.cardColor,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.lightTheme.colorScheme.shadow,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'GPS Distance',
                                  style:
                                      AppTheme.lightTheme.textTheme.titleMedium,
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'location_on',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 20,
                                    ),
                                    SizedBox(width: 2.w),
                                    Consumer<DistanceUnitManager>(
                                      builder:
                                          (context, distanceManager, child) {
                                        return Flexible(
                                          child: Text(
                                            '${distanceManager.getFormattedDistance(currentHoleData["distanceToPin"] as int)} to pin',
                                            style: AppTheme.dataTextStyle(
                                              isLight: true,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: OptimizedMiniScorecardWidget(
                  currentHole: currentHole,
                  scores: scores,
                  holeData: holeData,
                  onHoleTap: _navigateToHole,
                  onHoleLongPress: _showHoleDetailModal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
