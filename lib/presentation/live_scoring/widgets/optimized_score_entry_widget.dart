import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/optimized_score_celebration_widget.dart';

class OptimizedScoreEntryWidget extends StatefulWidget {
  final int par;
  final int currentScore;
  final Function(int) onScoreChanged;

  const OptimizedScoreEntryWidget({
    super.key,
    required this.par,
    required this.currentScore,
    required this.onScoreChanged,
  });

  @override
  State<OptimizedScoreEntryWidget> createState() =>
      _OptimizedScoreEntryWidgetState();
}

class _OptimizedScoreEntryWidgetState extends State<OptimizedScoreEntryWidget>
    with TickerProviderStateMixin {
  OverlayEntry? _celebrationOverlay;
  late AnimationController _scoreDisplayController;
  late AnimationController _buttonAnimationController;
  late Animation<double> _scoreScaleAnimation;
  late Animation<double> _scoreFadeAnimation;

  final Map<int, AnimationController> _buttonControllers = {};
  final Map<int, Animation<double>> _buttonScaleAnimations = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    try {
      // Score display animations
      _scoreDisplayController = AnimationController(
        duration:
            AnimationConfig.getScaledDuration(AnimationConfig.mediumDuration),
        vsync: this,
      );

      // Button tap animations
      _buttonAnimationController = AnimationController(
        duration:
            AnimationConfig.getScaledDuration(AnimationConfig.fastDuration),
        vsync: this,
      );

      _scoreScaleAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _scoreDisplayController,
        curve: AnimationConfig.bounceInCurve,
      ));

      _scoreFadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _scoreDisplayController,
        curve: AnimationConfig.fadeInCurve,
      ));

      // Initialize button controllers - Include more options for par 5
      _initializeButtonControllers();
    } catch (e) {
      debugPrint('Error initializing score entry animations: $e');
    }
  }

  @override
  void didUpdateWidget(OptimizedScoreEntryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentScore != oldWidget.currentScore &&
        widget.currentScore > 0) {
      _animateScoreChange();
    }

    // Re-initialize button controllers if par changed
    if (widget.par != oldWidget.par) {
      _disposeButtonControllers();
      _initializeButtonControllers();
    }
  }

  void _animateScoreChange() {
    try {
      _scoreDisplayController.reset();
      _scoreDisplayController.forward();
    } catch (e) {
      debugPrint('Error animating score change: $e');
    }
  }

  void _disposeButtonControllers() {
    try {
      for (final controller in _buttonControllers.values) {
        controller.dispose();
      }
      _buttonControllers.clear();
      _buttonScaleAnimations.clear();
    } catch (e) {
      debugPrint('Error disposing button controllers: $e');
    }
  }

  void _initializeButtonControllers() {
    try {
      // Initialize button controllers - Include more options for par 5
      final itemCount = widget.par >= 5 ? 9 : 8;
      for (int i = 0; i < itemCount; i++) {
        final score = widget.par >= 5 ? widget.par - 3 + i : widget.par - 2 + i;
        final controller = AnimationController(
          duration:
              AnimationConfig.getScaledDuration(AnimationConfig.fastDuration),
          vsync: this,
        );
        _buttonControllers[score] = controller;
        _buttonScaleAnimations[score] = Tween<double>(
          begin: 1.0,
          end: AnimationConfig.touchScaleDown,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: AnimationConfig.fadeInCurve,
        ));
      }
    } catch (e) {
      debugPrint('Error initializing button controllers: $e');
    }
  }

  @override
  void dispose() {
    try {
      _scoreDisplayController.dispose();
      _buttonAnimationController.dispose();
      _disposeButtonControllers();
      _celebrationOverlay?.remove();
    } catch (e) {
      debugPrint('Error disposing score entry controllers: $e');
    }
    super.dispose();
  }

  String _getScoreLabel(int score, int par) {
    final diff = score - par;
    if (diff == 0) return 'PAR';
    if (diff == -4) return 'CONDOR';
    if (diff == -3) return 'ALBATROSS';
    if (diff == -2) return 'EAGLE';
    if (diff == -1) return 'BIRDIE';
    if (diff == 1) return 'BOGEY';
    if (diff == 2) return 'DOUBLE';
    if (diff == 3) return 'TRIPLE';
    if (diff > 3) return '+$diff';
    return diff < 0 ? '$diff' : '+$diff';
  }

  Color _getScoreColor(int score, int par) {
    final diff = score - par;
    if (diff == -4) return AppTheme.birdieColors['condor']!;
    if (diff == -3) return AppTheme.birdieColors['albatross']!;
    if (diff == -2) return AppTheme.birdieColors['eagle']!;
    if (diff == -1) return AppTheme.birdieColors['birdie']!;
    if (diff == 0) return AppTheme.lightTheme.colorScheme.primary;
    if (diff == 1) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  bool _isBirdieOrBetter(int score, int par) {
    return score < par;
  }

  void _showCelebration(int score, int par) {
    final scoreLabel = _getScoreLabel(score, par);

    if (_isBirdieOrBetter(score, par)) {
      _celebrationOverlay = _createCelebrationOverlay(scoreLabel, score, par);
      Overlay.of(context).insert(_celebrationOverlay!);
    }
  }

  OverlayEntry _createCelebrationOverlay(String scoreType, int score, int par) {
    return OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withValues(alpha: 0.8),
        child: Center(
          child: OptimizedScoreCelebrationWidget(
            scoreType: scoreType,
            score: score,
            par: par,
            onAnimationComplete: () {
              _celebrationOverlay?.remove();
              _celebrationOverlay = null;
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleScoreSelection(int score) async {
    try {
      // Immediate visual feedback
      final controller = _buttonControllers[score];
      if (controller != null && !controller.isAnimating) {
        await controller.forward();
        await controller.reverse();
      }

      // Haptic feedback with error handling
      try {
        HapticFeedback.mediumImpact();
      } catch (e) {
        debugPrint('Haptic feedback error: $e');
      }

      // Update score
      widget.onScoreChanged(score);

      // Show celebration if needed
      await Future.delayed(AnimationConfig.hapticDelay);
      _showCelebration(score, widget.par);
    } catch (e) {
      debugPrint('Error handling score selection: $e');
      // Still update score even if animation fails
      widget.onScoreChanged(score);
    }
  }

  Widget _buildScoreDisplay() {
    if (widget.currentScore <= 0) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: Listenable.merge([_scoreScaleAnimation, _scoreFadeAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: _scoreFadeAnimation.value,
          child: Transform.scale(
            scale: _scoreScaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getScoreColor(widget.currentScore, widget.par)
                        .withValues(alpha: 0.1),
                    _getScoreColor(widget.currentScore, widget.par)
                        .withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: _getScoreColor(widget.currentScore, widget.par),
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getScoreColor(widget.currentScore, widget.par)
                        .withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        _getScoreColor(widget.currentScore, widget.par),
                        _getScoreColor(widget.currentScore, widget.par)
                            .withValues(alpha: 0.8),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      '${widget.currentScore}',
                      style: AppTheme.dataTextStyle(
                        isLight: true,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ).copyWith(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color:
                                _getScoreColor(widget.currentScore, widget.par)
                                    .withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _getScoreLabel(widget.currentScore, widget.par),
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: _getScoreColor(widget.currentScore, widget.par),
                      fontWeight: FontWeight.w600,
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

  Widget _buildScoreButton(int score, int index) {
    final isSelected = widget.currentScore == score;
    final scoreColor = _getScoreColor(score, widget.par);
    final controller = _buttonControllers[score];
    final animation = _buttonScaleAnimations[score];

    // Calculate responsive button width - minimum 60px, maximum 20% of screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = (screenWidth * 0.18).clamp(60.0, screenWidth * 0.22);

    return AnimatedBuilder(
      animation: animation ?? const AlwaysStoppedAnimation(1.0),
      builder: (context, child) {
        return Transform.scale(
          scale: animation?.value ?? 1.0,
          child: GestureDetector(
            onTapDown: (_) => controller?.forward(),
            onTapUp: (_) => controller?.reverse(),
            onTapCancel: () => controller?.reverse(),
            onTap: () => _handleScoreSelection(score),
            child: AnimatedContainer(
              duration: AnimationConfig.getScaledDuration(
                  AnimationConfig.mediumDuration),
              curve: AnimationConfig.bounceInCurve,
              margin: EdgeInsets.symmetric(horizontal: 1.5.w),
              width: buttonWidth,
              height: 11.h, // Fixed height for consistency
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          scoreColor,
                          scoreColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                color: isSelected ? null : AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: isSelected
                      ? scoreColor
                      : AppTheme.lightTheme.dividerColor,
                  width: isSelected ? 3.0 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: scoreColor.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: scoreColor.withValues(alpha: 0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.shadow,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      '$score',
                      style: AppTheme.dataTextStyle(
                        isLight: true,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ).copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : scoreColor,
                        shadows: isSelected
                            ? [
                                Shadow(
                                  color: scoreColor.withValues(alpha: 0.5),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Flexible(
                    child: Text(
                      _getScoreLabel(score, widget.par),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.8)
                            : scoreColor.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Text(
            'Enter Score',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              shadows: [
                Shadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Score display with animations
          _buildScoreDisplay(),
          if (widget.currentScore > 0) SizedBox(height: 3.h),

          // Optimized score selection buttons with improved scrolling
          SizedBox(
            height: 12.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(
                  widget.par >= 5 ? 9 : 8,
                  (index) {
                    final score = widget.par >= 5
                        ? widget.par - 3 + index
                        : widget.par - 2 + index;
                    return _buildScoreButton(score, index);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
