import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_schedule_widget.dart';
import './widgets/round_card_widget.dart';
import './widgets/round_edit_modal_widget.dart';
import './widgets/schedule_calendar_widget.dart';
import './widgets/schedule_filter_widget.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({super.key});

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'upcoming'; // Changed default filter to 'upcoming'
  bool _isRefreshing = false;
  bool _showCalendar = true;

  // Mock data for scheduled rounds - Updated to have more upcoming rounds
  final List<Map<String, dynamic>> _scheduledRounds = [
    {
      'id': '1',
      'courseName': 'Pebble Beach Golf Links',
      'date': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      'time': '08:30',
      'format': 'Stroke Play',
      'players': [
        {
          'id': '1',
          'name': 'Mike Chen',
          'avatar':
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
          'imageUrl':
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face'
        },
        {
          'id': '2',
          'name': 'Sarah Wilson',
          'avatar':
              'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
          'imageUrl':
              'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face'
        },
        {
          'id': '3',
          'name': 'Tom Rodriguez',
          'avatar':
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
          'imageUrl':
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face'
        }
      ],
      'notes': 'Morning round with great weather expected',
      'status': 'confirmed'
    },
    {
      'id': '2',
      'courseName': 'Augusta National Golf Club',
      'date': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      'time': '14:00',
      'format': 'Match Play',
      'players': [
        {
          'id': '4',
          'name': 'Lisa Johnson',
          'avatar':
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
          'imageUrl':
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face'
        }
      ],
      'notes': 'Weekend tournament round',
      'status': 'pending'
    },
    {
      'id': '3',
      'courseName': 'St. Andrews Links',
      'date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      'time': '10:15',
      'format': 'Stableford',
      'players': [
        {
          'id': '5',
          'name': 'David Park',
          'avatar':
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
          'imageUrl':
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face'
        },
        {
          'id': '6',
          'name': 'Emma Thompson',
          'avatar':
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
          'imageUrl':
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face'
        }
      ],
      'notes': 'Historic course experience',
      'status': 'confirmed'
    },
    {
      'id': '4',
      'courseName': 'TPC Sawgrass',
      'date': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
      'time': '09:45',
      'format': 'Stroke Play',
      'players': [
        {
          'id': '7',
          'name': 'John Smith',
          'avatar':
              'https://images.unsplash.com/photo-1507038732509-8b1a9da48ec0?w=150&h=150&fit=crop&crop=face',
          'imageUrl':
              'https://images.unsplash.com/photo-1507038732509-8b1a9da48ec0?w=150&h=150&fit=crop&crop=face'
        },
        {
          'id': '8',
          'name': 'Jane Doe',
          'avatar':
              'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=150&h=150&fit=crop&crop=face',
          'imageUrl':
              'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=150&h=150&fit=crop&crop=face'
        }
      ],
      'notes': 'Challenge the famous 17th island green',
      'status': 'confirmed'
    },
    {
      'id': '5',
      'courseName': 'Bethpage Black',
      'date': DateTime.now().add(const Duration(days: 14)).toIso8601String(),
      'time': '07:30',
      'format': 'Stroke Play',
      'players': [
        {
          'id': '9',
          'name': 'Robert Johnson',
          'avatar':
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
          'imageUrl':
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face'
        }
      ],
      'notes': 'Early morning championship round',
      'status': 'confirmed'
    }
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    _refreshController.reset();

    // Show success feedback
    HapticFeedback.lightImpact();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Schedule updated',
            style: Theme.of(context).snackBarTheme.contentTextStyle,
          ),
          backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
          behavior: Theme.of(context).snackBarTheme.behavior,
          shape: Theme.of(context).snackBarTheme.shape,
        ),
      );
    }
  }

  List<Map<String, dynamic>> _getFilteredRounds() {
    final now = DateTime.now();

    switch (_selectedFilter) {
      case 'week':
        final weekFromNow = now.add(const Duration(days: 7));
        return _scheduledRounds.where((round) {
          final roundDate = DateTime.parse(round['date']);
          return roundDate.isAfter(now) && roundDate.isBefore(weekFromNow);
        }).toList();
      case 'month':
        final monthFromNow = DateTime(now.year, now.month + 1, now.day);
        return _scheduledRounds.where((round) {
          final roundDate = DateTime.parse(round['date']);
          return roundDate.isAfter(now) && roundDate.isBefore(monthFromNow);
        }).toList();
      case 'upcoming':
        return _scheduledRounds.where((round) {
          final roundDate = DateTime.parse(round['date']);
          return roundDate.isAfter(now);
        }).toList();
      default:
        return _scheduledRounds;
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onDayTapped(List<Map<String, dynamic>> rounds) {
    _showDayRoundsBottomSheet(rounds);
  }

  void _showDayRoundsBottomSheet(List<Map<String, dynamic>> rounds) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: Theme.of(context).bottomSheetTheme.shape,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 12.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Rounds on ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 2.h),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: rounds.length,
                    itemBuilder: (context, index) {
                      return _buildRoundCard(rounds[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoundCard(Map<String, dynamic> roundData) {
    return RoundCardWidget(
      roundData: roundData,
      onTap: () => _showRoundDetails(roundData),
      onEdit: () => _editRound(roundData),
      onCancel: () => _cancelRound(roundData),
      onMessage: () => _messageGroup(roundData),
      onDirections: () => _getDirections(roundData),
    );
  }

  void _showRoundDetails(Map<String, dynamic> roundData) {
    final now = DateTime.now();
    final roundDate = DateTime.parse(roundData['date']);
    final isUpcoming = roundDate.isAfter(now);

    // Navigate to round details screen
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: Theme.of(context).bottomSheetTheme.shape,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        height: isUpcoming ? 80.h : 70.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Round Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            // Round details content would go here
            Text(
              'Course: ${roundData['courseName']}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Date: ${roundData['date']} at ${roundData['time']}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Format: ${roundData['format']}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (roundData['notes'] != null && roundData['notes'].isNotEmpty)
              Text(
                'Notes: ${roundData['notes']}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            SizedBox(height: 3.h),

            // Start Round button for upcoming rounds
            if (isUpcoming) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close modal first
                    _startRound(roundData);
                  },
                  icon: CustomIconWidget(
                    iconName: 'play_arrow',
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                  label: Text(
                    'Start Round',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ],
        ),
      ),
    );
  }

  void _startRound(Map<String, dynamic> roundData) {
    HapticFeedback.mediumImpact();

    // Navigate to live scoring with round data
    Navigator.pushNamed(
      context,
      AppRoutes.liveScoring,
      arguments: {
        'roundData': roundData,
        'courseName': roundData['courseName'],
        'players': roundData['players'],
        'format': roundData['format'],
      },
    );

    // Show feedback that round has started
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Round started - ${roundData['courseName']}',
          style: Theme.of(context).snackBarTheme.contentTextStyle,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'View',
          textColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.liveScoring);
          },
        ),
      ),
    );
  }

  void _editRound(Map<String, dynamic> roundData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => RoundEditModalWidget(
          roundData: roundData,
          onSave: (updatedRound) {
            _updateRound(updatedRound);
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _updateRound(Map<String, dynamic> updatedRound) {
    setState(() {
      final index = _scheduledRounds.indexWhere(
        (round) => round['id'] == updatedRound['id'],
      );
      if (index != -1) {
        _scheduledRounds[index] = updatedRound;
      }
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Round updated successfully',
          style: Theme.of(context).snackBarTheme.contentTextStyle,
        ),
        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
        behavior: Theme.of(context).snackBarTheme.behavior,
        shape: Theme.of(context).snackBarTheme.shape,
      ),
    );
  }

  void _cancelRound(Map<String, dynamic> roundData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Round',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Text(
          'Are you sure you want to cancel this round? This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Keep Round',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _scheduledRounds.removeWhere(
                  (round) => round['id'] == roundData['id'],
                );
              });
              Navigator.of(context).pop();

              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Round cancelled',
                    style: Theme.of(context).snackBarTheme.contentTextStyle,
                  ),
                  backgroundColor:
                      Theme.of(context).snackBarTheme.backgroundColor,
                  behavior: Theme.of(context).snackBarTheme.behavior,
                  shape: Theme.of(context).snackBarTheme.shape,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              'Cancel Round',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _messageGroup(Map<String, dynamic> roundData) {
    // Implement group messaging functionality
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening group chat...',
          style: Theme.of(context).snackBarTheme.contentTextStyle,
        ),
        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
        behavior: Theme.of(context).snackBarTheme.behavior,
        shape: Theme.of(context).snackBarTheme.shape,
      ),
    );
  }

  void _getDirections(Map<String, dynamic> roundData) {
    // Implement directions functionality
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening directions to ${roundData['courseName']}...',
          style: Theme.of(context).snackBarTheme.contentTextStyle,
        ),
        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
        behavior: Theme.of(context).snackBarTheme.behavior,
        shape: Theme.of(context).snackBarTheme.shape,
      ),
    );
  }

  void _toggleCalendarView() {
    setState(() {
      _showCalendar = !_showCalendar;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredRounds = _getFilteredRounds();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Theme.of(context).colorScheme.primary,
          child: filteredRounds.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: 80.h,
                    child: EmptyScheduleWidget(
                      onBookRound: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pushNamed(context, AppRoutes.scheduleRound);
                      },
                    ),
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      expandedHeight: 12.h,
                      floating: true,
                      pinned: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          'Schedule',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        centerTitle: false,
                        titlePadding: EdgeInsets.only(left: 4.w, bottom: 2.h),
                      ),
                      actions: [
                        IconButton(
                          onPressed: _toggleCalendarView,
                          icon: CustomIconWidget(
                            iconName: _showCalendar
                                ? 'view_list'
                                : 'calendar_view_month',
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Settings or more options
                          },
                          icon: CustomIconWidget(
                            iconName: 'more_vert',
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    // Filter Options
                    SliverToBoxAdapter(
                      child: ScheduleFilterWidget(
                        selectedFilter: _selectedFilter,
                        onFilterChanged: (filter) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                      ),
                    ),

                    // Calendar Widget (conditional)
                    if (_showCalendar)
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          child: ScheduleCalendarWidget(
                            selectedDate: _selectedDate,
                            rounds: filteredRounds,
                            onDateSelected: _onDateSelected,
                            onDayTapped: _onDayTapped,
                          ),
                        ),
                      ),

                    // Section Header
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upcoming Rounds',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              '${filteredRounds.length} round${filteredRounds.length != 1 ? 's' : ''}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Rounds List
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildRoundCard(filteredRounds[index]);
                        },
                        childCount: filteredRounds.length,
                      ),
                    ),

                    // Bottom padding reduced since FAB is removed
                    SliverToBoxAdapter(
                      child: SizedBox(height: 2.h),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
