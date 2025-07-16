import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScheduleCalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final List<Map<String, dynamic>> rounds;
  final Function(DateTime) onDateSelected;
  final Function(List<Map<String, dynamic>>) onDayTapped;

  const ScheduleCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.rounds,
    required this.onDateSelected,
    required this.onDayTapped,
  });

  @override
  State<ScheduleCalendarWidget> createState() => _ScheduleCalendarWidgetState();
}

class _ScheduleCalendarWidgetState extends State<ScheduleCalendarWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  PageController? _pageController;
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _pageController = PageController();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getRoundsForDate(DateTime date) {
    return widget.rounds.where((round) {
      final roundDate = DateTime.parse(round['date']);
      return roundDate.year == date.year &&
          roundDate.month == date.month &&
          roundDate.day == date.day;
    }).toList();
  }

  void _scheduleNewRound(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    // Don't allow scheduling rounds on past dates
    if (selectedDay.isBefore(today)) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cannot schedule rounds on past dates',
            style: Theme.of(context).snackBarTheme.contentTextStyle,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    // Navigate to schedule round screen with the selected date
    Navigator.pushNamed(
      context,
      AppRoutes.scheduleRound,
      arguments: {
        'selectedDate': date,
      },
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isSelected = widget.selectedDate.year == date.year &&
        widget.selectedDate.month == date.month &&
        widget.selectedDate.day == date.day;
    final isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;
    final roundsForDay = _getRoundsForDate(date);
    final hasRounds = roundsForDay.isNotEmpty;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);
    final isPastDate = selectedDay.isBefore(today);

    return GestureDetector(
      onTap: () {
        widget.onDateSelected(date);
        if (hasRounds) {
          widget.onDayTapped(roundsForDay);
        } else {
          // Schedule new round on empty days
          _scheduleNewRound(date);
        }
      },
      child: Container(
        margin: EdgeInsets.all(0.5.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : isToday
                  ? Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : isToday
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
            width: isSelected || isToday ? 2 : 0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.day.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected || isToday
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: isPastDate
                        ? Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.4)
                        : isSelected
                            ? Theme.of(context).colorScheme.primary
                            : isToday
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            if (hasRounds) ...[
              SizedBox(height: 0.5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: roundsForDay.take(3).map((round) {
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
            ] else if (!isPastDate) ...[
              // Show a subtle plus icon for empty future dates
              SizedBox(height: 0.5.h),
              CustomIconWidget(
                iconName: 'add_circle_outline',
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.5),
                size: 12,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeekHeader() {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      children: weekDays.map((day) {
        return Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 1; i < firstDayWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Add cells for each day of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      dayWidgets.add(_buildDayCell(date));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GlassCardWidget(
        child: Column(
          children: [
            // Calendar Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _previousMonth,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'chevron_left',
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
                Text(
                  '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                GestureDetector(
                  onTap: _nextMonth,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildWeekHeader(),
            _buildCalendarGrid(),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}
