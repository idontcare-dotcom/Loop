import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OptimizedMiniScorecardWidget extends StatefulWidget {
  final int currentHole;
  final Map<int, int> scores;
  final List<Map<String, dynamic>> holeData;
  final Function(int) onHoleTap;
  final Function(int) onHoleLongPress;

  const OptimizedMiniScorecardWidget({
    super.key,
    required this.currentHole,
    required this.scores,
    required this.holeData,
    required this.onHoleTap,
    required this.onHoleLongPress,
  });

  @override
  State<OptimizedMiniScorecardWidget> createState() =>
      _OptimizedMiniScorecardWidgetState();
}

class _OptimizedMiniScorecardWidgetState
    extends State<OptimizedMiniScorecardWidget> with TickerProviderStateMixin {
  late AnimationController _totalScoreController;
  late Animation<double> _totalScoreAnimation;
  late Animation<Color?> _totalScoreColorAnimation;

  final Map<int, AnimationController> _holeControllers = {};
  final Map<int, Animation<double>> _holeScaleAnimations = {};
  final Map<int, Animation<double>> _holeGlowAnimations = {};
  final Map<int, AnimationController> _holeGlowControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    try {
      // Total score animation
      _totalScoreController = AnimationController(
        duration:
            AnimationConfig.getScaledDuration(AnimationConfig.mediumDuration),
        vsync: this,
      );

      _totalScoreAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _totalScoreController,
        curve: AnimationConfig.bounceInCurve,
      ));

      final totalScore = _getTotalScore();
      final totalPar = _getTotalPar();

      _totalScoreColorAnimation = ColorTween(
        begin: _getScoreColor(totalScore, totalPar).withValues(alpha: 0.3),
        end: _getScoreColor(totalScore, totalPar),
      ).animate(CurvedAnimation(
        parent: _totalScoreController,
        curve: AnimationConfig.fadeInCurve,
      ));

      // Initialize hole controllers with error handling
      for (int hole = 1; hole <= 18; hole++) {
        final controller = AnimationController(
          duration:
              AnimationConfig.getScaledDuration(AnimationConfig.fastDuration),
          vsync: this,
        );

        final glowController = AnimationController(
          duration: AnimationConfig.getScaledDuration(
              const Duration(milliseconds: 2000)),
          vsync: this,
        );

        _holeControllers[hole] = controller;
        _holeGlowControllers[hole] = glowController;

        _holeScaleAnimations[hole] = Tween<double>(
          begin: 1.0,
          end: AnimationConfig.touchScaleDown,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: AnimationConfig.fadeInCurve,
        ));

        _holeGlowAnimations[hole] = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: glowController,
          curve: Curves.easeInOut,
        ));

        // Start pulsing glow for current hole
        if (hole == widget.currentHole) {
          glowController.repeat(reverse: true);
        }
      }
    } catch (e) {
      // Handle animation initialization errors gracefully
      debugPrint('Error initializing scorecard animations: $e');
    }
  }

  @override
  void didUpdateWidget(OptimizedMiniScorecardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    try {
      // Animate total score changes
      if (_getTotalScore() != _getTotalScoreFromScores(oldWidget.scores)) {
        _totalScoreController.reset();
        _totalScoreController.forward();
      }

      // Update current hole glow
      if (widget.currentHole != oldWidget.currentHole) {
        // Stop old hole glow
        final oldController = _holeGlowControllers[oldWidget.currentHole];
        oldController?.stop();
        oldController?.reset();

        // Start new hole glow
        final newController = _holeGlowControllers[widget.currentHole];
        newController?.repeat(reverse: true);
      }
    } catch (e) {
      debugPrint('Error updating scorecard widget: $e');
    }
  }

  int _getTotalScoreFromScores(Map<int, int> scores) {
    try {
      return scores.values.fold(0, (sum, score) => sum + score);
    } catch (e) {
      debugPrint('Error calculating total score: $e');
      return 0;
    }
  }

  @override
  void dispose() {
    try {
      _totalScoreController.dispose();
      for (final controller in _holeControllers.values) {
        controller.dispose();
      }
      for (final controller in _holeGlowControllers.values) {
        controller.dispose();
      }
    } catch (e) {
      debugPrint('Error disposing scorecard controllers: $e');
    }
    super.dispose();
  }

  Color _getScoreColor(int? score, int par) {
    if (score == null || score == 0) {
      return AppTheme.lightTheme.colorScheme.outline;
    }
    final diff = score - par;
    if (diff == -4) return AppTheme.birdieColors['condor']!;
    if (diff == -3) return AppTheme.birdieColors['albatross']!;
    if (diff == -2) return AppTheme.birdieColors['eagle']!;
    if (diff == -1) return AppTheme.birdieColors['birdie']!;
    if (diff == 0) return AppTheme.lightTheme.colorScheme.primary;
    if (diff == 1) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  int _getTotalScore() {
    try {
      return widget.scores.values.fold(0, (sum, score) => sum + score);
    } catch (e) {
      debugPrint('Error getting total score: $e');
      return 0;
    }
  }

  int _getTotalPar() {
    try {
      return widget.holeData
          .fold(0, (sum, hole) => sum + (hole["par"] as int? ?? 4));
    } catch (e) {
      debugPrint('Error getting total par: $e');
      return 72; // Default 18-hole par
    }
  }

  Future<void> _handleHoleTap(int hole) async {
    try {
      // Visual feedback
      final controller = _holeControllers[hole];
      if (controller != null && controller.isCompleted == false) {
        await controller.forward();
        await controller.reverse();
      }

      // Haptic feedback with error handling
      try {
        HapticFeedback.lightImpact();
      } catch (e) {
        debugPrint('Haptic feedback error: $e');
      }

      // Trigger callback
      await Future.delayed(AnimationConfig.hapticDelay);
      widget.onHoleTap(hole);
    } catch (e) {
      debugPrint('Error handling hole tap: $e');
      // Still call callback even if animation fails
      widget.onHoleTap(hole);
    }
  }

  void _handleHoleLongPress(int hole) {
    try {
      HapticFeedback.mediumImpact();
      widget.onHoleLongPress(hole);
    } catch (e) {
      debugPrint('Error handling hole long press: $e');
      // Still call callback even if haptic feedback fails
      widget.onHoleLongPress(hole);
    }
  }

  Widget _buildTotalScoreDisplay() {
    final totalScore = _getTotalScore();
    final totalPar = _getTotalPar();
    final scoreToPar = totalScore > 0 ? totalScore - totalPar : 0;

    if (widget.scores.isEmpty) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation:
          Listenable.merge([_totalScoreAnimation, _totalScoreColorAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _totalScoreAnimation.value,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _totalScoreColorAnimation.value?.withValues(alpha: 0.1) ??
                      Colors.transparent,
                  _totalScoreColorAnimation.value?.withValues(alpha: 0.2) ??
                      Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: _totalScoreColorAnimation.value ?? Colors.transparent,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      _totalScoreColorAnimation.value?.withValues(alpha: 0.3) ??
                          Colors.transparent,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              scoreToPar == 0
                  ? 'E'
                  : scoreToPar > 0
                      ? '+$scoreToPar'
                      : '$scoreToPar',
              style: AppTheme.dataTextStyle(
                isLight: true,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ).copyWith(
                color: _totalScoreColorAnimation.value,
                shadows: [
                  Shadow(
                    color: _totalScoreColorAnimation.value
                            ?.withValues(alpha: 0.3) ??
                        Colors.transparent,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHoleCard(int hole, int index) {
    // Add bounds checking for holeData array
    if (index >= widget.holeData.length) {
      return const SizedBox.shrink();
    }

    final holeInfo = widget.holeData[index];
    final par = holeInfo["par"] as int? ?? 4; // Default to par 4 if null
    final score = widget.scores[hole];
    final isCurrentHole = hole == widget.currentHole;
    final scoreColor = _getScoreColor(score, par);

    final scaleAnimation = _holeScaleAnimations[hole];
    final glowAnimation = _holeGlowAnimations[hole];

    // Calculate responsive card width - minimum 50px
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth / 18 * 0.8).clamp(50.0, 80.0);

    return AnimatedBuilder(
      animation: Listenable.merge([
        scaleAnimation ?? const AlwaysStoppedAnimation(1.0),
        glowAnimation ?? const AlwaysStoppedAnimation(0.0),
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation?.value ?? 1.0,
          child: GestureDetector(
            onTapDown: (_) => _holeControllers[hole]?.forward(),
            onTapUp: (_) => _holeControllers[hole]?.reverse(),
            onTapCancel: () => _holeControllers[hole]?.reverse(),
            onTap: () => _handleHoleTap(hole),
            onLongPress: () => _handleHoleLongPress(hole),
            child: AnimatedContainer(
              duration: AnimationConfig.getScaledDuration(
                  AnimationConfig.mediumDuration),
              curve: AnimationConfig.bounceInCurve,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              width: cardWidth,
              height: 11.h, // Fixed height for consistency
              decoration: BoxDecoration(
                gradient: isCurrentHole
                    ? LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : score != null
                        ? LinearGradient(
                            colors: [
                              scoreColor.withValues(alpha: 0.1),
                              scoreColor.withValues(alpha: 0.15),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : null,
                color: isCurrentHole || score != null
                    ? null
                    : AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: isCurrentHole
                      ? AppTheme.lightTheme.colorScheme.primary
                      : score != null
                          ? scoreColor
                          : AppTheme.lightTheme.dividerColor,
                  width: isCurrentHole ? 3.0 : 1.0,
                ),
                boxShadow: [
                  if (isCurrentHole) ...[
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary.withValues(
                          alpha: 0.3 + (glowAnimation?.value ?? 0.0) * 0.2),
                      blurRadius: 8 + (glowAnimation?.value ?? 0.0) * 4,
                      offset: const Offset(0, 4),
                    ),
                  ] else if (score != null) ...[
                    BoxShadow(
                      color: scoreColor.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ] else ...[
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      '$hole',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isCurrentHole
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        shadows: isCurrentHole
                            ? [
                                Shadow(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.5),
                                  blurRadius: 1,
                                  offset: const Offset(0, 0.5),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: cardWidth * 0.7,
                      decoration: BoxDecoration(
                        gradient: isCurrentHole
                            ? LinearGradient(
                                colors: [
                                  AppTheme.lightTheme.colorScheme.onPrimary
                                      .withValues(alpha: 0.2),
                                  AppTheme.lightTheme.colorScheme.onPrimary
                                      .withValues(alpha: 0.1),
                                ],
                              )
                            : null,
                        color: isCurrentHole ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          score?.toString() ?? '-',
                          style: AppTheme.dataTextStyle(
                            isLight: true,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ).copyWith(
                            color: isCurrentHole
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : score != null
                                    ? scoreColor
                                    : AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                            shadows: isCurrentHole || score != null
                                ? [
                                    Shadow(
                                      color: (isCurrentHole
                                              ? AppTheme.lightTheme.colorScheme
                                                  .primary
                                              : scoreColor)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 1,
                                      offset: const Offset(0, 0.5),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Flexible(
                    child: Text(
                      'Par $par',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: isCurrentHole
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.8)
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Scorecard',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                shadows: [
                  Shadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 1,
                    offset: const Offset(0, 0.5),
                  ),
                ],
              ),
            ),
            _buildTotalScoreDisplay(),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 12.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(18, (index) {
                final hole = index + 1;
                return _buildHoleCard(hole, index);
              }),
            ),
          ),
        ),
      ],
    );
  }
}
