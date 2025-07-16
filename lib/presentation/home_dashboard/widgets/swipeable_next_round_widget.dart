import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './next_round_card_widget.dart';

class SwipeableNextRoundWidget extends StatefulWidget {
  final List<Map<String, dynamic>> upcomingRounds;
  final Function(Map<String, dynamic>) onRoundTap;
  final Function(Map<String, dynamic>) onMessageGroup;
  final Function(Map<String, dynamic>) onGetDirections;
  final Function(Map<String, dynamic>) onCancelRound;

  const SwipeableNextRoundWidget({
    super.key,
    required this.upcomingRounds,
    required this.onRoundTap,
    required this.onMessageGroup,
    required this.onGetDirections,
    required this.onCancelRound,
  });

  @override
  State<SwipeableNextRoundWidget> createState() =>
      _SwipeableNextRoundWidgetState();
}

class _SwipeableNextRoundWidgetState extends State<SwipeableNextRoundWidget> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (mounted) {
      setState(() {
        _currentPage = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle empty state
    if (widget.upcomingRounds.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 26.h,
                minHeight: 20.h,
              ),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: widget.upcomingRounds.length,
                itemBuilder: (context, index) {
                  try {
                    final roundData = widget.upcomingRounds[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: NextRoundCardWidget(
                        roundData: roundData,
                        onTap: () => widget.onRoundTap(roundData),
                        onMessageGroup: () => widget.onMessageGroup(roundData),
                        onGetDirections: () =>
                            widget.onGetDirections(roundData),
                        onCancelRound: () => widget.onCancelRound(roundData),
                      ),
                    );
                  } catch (e) {
                    debugPrint('Error building round card: $e');
                    return _buildErrorCard();
                  }
                },
              ),
            ),
            if (widget.upcomingRounds.length > 1) ...[
              SizedBox(height: 2.h),
              _buildPageIndicator(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.upcomingRounds.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      constraints: BoxConstraints(
        minHeight: 20.h,
      ),
      child: Card(
        elevation: 4,
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'golf_course',
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.6),
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'No Upcoming Rounds',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Schedule your next round to see it here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Card(
        elevation: 4,
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'error',
                color: Theme.of(context).colorScheme.error,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'Error Loading Round',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Unable to display round information',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
