import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoundCardWidget extends StatefulWidget {
  final Map<String, dynamic> roundData;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onCancel;
  final VoidCallback onMessage;
  final VoidCallback onDirections;

  const RoundCardWidget({
    super.key,
    required this.roundData,
    required this.onTap,
    required this.onEdit,
    required this.onCancel,
    required this.onMessage,
    required this.onDirections,
  });

  @override
  State<RoundCardWidget> createState() => _RoundCardWidgetState();
}

class _RoundCardWidgetState extends State<RoundCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _swipeController;
  late AnimationController _pressController;
  late Animation<Offset> _swipeAnimation;
  late Animation<double> _pressAnimation;

  double _swipePosition = 0.0;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _pressController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);

    _swipeAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.3, 0)).animate(
            CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));

    _pressAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _pressController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _swipeController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _onSwipeUpdate(DragUpdateDetails details) {
    setState(() {
      _swipePosition += details.delta.dx;
      _swipePosition = _swipePosition.clamp(-100.0, 100.0);
    });
  }

  void _onSwipeEnd(DragEndDetails details) {
    if (_swipePosition.abs() > 50) {
      // Trigger haptic feedback
      HapticFeedback.lightImpact();

      if (_swipePosition > 0) {
        // Right swipe - Edit/Cancel actions
        _showRightActions();
      } else {
        // Left swipe - Message/Directions actions
        _showLeftActions();
      }
    }

    // Reset position
    setState(() {
      _swipePosition = 0.0;
    });
  }

  void _showRightActions() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
        shape: Theme.of(context).bottomSheetTheme.shape,
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 2.h),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'edit',
                      color: Theme.of(context).colorScheme.primary,
                      size: 24),
                  title: Text('Edit Details',
                      style: Theme.of(context).textTheme.bodyLarge),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onEdit();
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'cancel',
                      color: Theme.of(context).colorScheme.error,
                      size: 24),
                  title: Text('Cancel Round',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error)),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onCancel();
                  }),
              SizedBox(height: 2.h),
            ])));
  }

  void _showLeftActions() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
        shape: Theme.of(context).bottomSheetTheme.shape,
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 2.h),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'message',
                      color: Theme.of(context).colorScheme.secondary,
                      size: 24),
                  title: Text('Message Group',
                      style: Theme.of(context).textTheme.bodyLarge),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onMessage();
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'directions',
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 24),
                  title: Text('Get Directions',
                      style: Theme.of(context).textTheme.bodyLarge),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onDirections();
                  }),
              SizedBox(height: 2.h),
            ])));
  }

  Widget _buildPlayerAvatars() {
    final players =
        widget.roundData['players'] as List<Map<String, dynamic>>? ?? [];

    return SizedBox(
        height: 32,
        child: Stack(
            children: players.take(3).map((player) {
          final index = players.indexOf(player);
          return Positioned(
              left: index * 20.0,
              child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2)),
                  child: ClipOval(
                      child: CustomImageWidget(
                          imageUrl: player['imageUrl'] ?? '',
                          fit: BoxFit.cover,
                          width: 32,
                          height: 32))));
        }).toList()));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final roundDate = DateTime.parse(widget.roundData['date']);
    final isUpcoming = roundDate.isAfter(now);

    return GestureDetector(
        onPanUpdate: _onSwipeUpdate,
        onPanEnd: _onSwipeEnd,
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _pressController.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _pressController.reverse();

          // If it's an upcoming round, show start round option, otherwise show details
          if (isUpcoming) {
            _showStartRoundDialog();
          } else {
            widget.onTap();
          }
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _pressController.reverse();
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          widget.onEdit();
        },
        child: AnimatedBuilder(
            animation: _pressAnimation,
            builder: (context, child) {
              return Transform.scale(
                  scale: _pressAnimation.value,
                  child: Transform.translate(
                      offset: Offset(_swipePosition * 0.01, 0),
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          child: GlassCardWidget(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Row(children: [
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(
                                            widget.roundData['courseName'] ??
                                                'Unknown Course',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        SizedBox(height: 0.5.h),
                                        Row(children: [
                                          CustomIconWidget(
                                              iconName: 'schedule',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.7),
                                              size: 16),
                                          SizedBox(width: 1.w),
                                          Text(
                                              '${widget.roundData['date']} • ${widget.roundData['time']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                              alpha: 0.7))),
                                        ]),
                                      ])),
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.w, vertical: 1.h),
                                      decoration: BoxDecoration(
                                          color: isUpcoming
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.1)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Text(
                                          isUpcoming
                                              ? 'Ready to Start'
                                              : widget.roundData['format'] ??
                                                  'Completed',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                  color: isUpcoming
                                                      ? Theme.of(context).colorScheme.primary
                                                      : Theme.of(context).colorScheme.secondary,
                                                  fontWeight: FontWeight.w500))),
                                ]),
                                SizedBox(height: 2.h),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        CustomIconWidget(
                                            iconName: 'group',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.7),
                                            size: 16),
                                        SizedBox(width: 2.w),
                                        _buildPlayerAvatars(),
                                        SizedBox(width: 2.w),
                                        Text(
                                            '+${((widget.roundData['players'] as List?)?.length ?? 1) - 3 > 0 ? ((widget.roundData['players'] as List?)?.length ?? 1) - 3 : 0}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(
                                                            alpha: 0.7))),
                                      ]),
                                      Row(children: [
                                        GestureDetector(
                                            onTap: widget.onMessage,
                                            child: Container(
                                                padding: EdgeInsets.all(2.w),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: CustomIconWidget(
                                                    iconName: 'chat',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    size: 16))),
                                        SizedBox(width: 2.w),
                                        GestureDetector(
                                            onTap: widget.onDirections,
                                            child: Container(
                                                padding: EdgeInsets.all(2.w),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiary
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: CustomIconWidget(
                                                    iconName: 'directions',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiary,
                                                    size: 16))),
                                      ]),
                                    ]),
                              ])))));
            }));
  }

  void _showStartRoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Start Round',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Text(
          'Ready to start your round at ${widget.roundData['courseName']}?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'View Details',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _startRound();
            },
            icon: CustomIconWidget(
              iconName: 'play_arrow',
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20,
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
            ),
          ),
        ],
      ),
    );
  }

  void _startRound() {
    HapticFeedback.mediumImpact();

    // Navigate to live scoring
    Navigator.pushNamed(
      context,
      AppRoutes.liveScoring,
      arguments: {
        'roundData': widget.roundData,
        'courseName': widget.roundData['courseName'],
        'players': widget.roundData['players'],
        'format': widget.roundData['format'],
      },
    );
  }
}
