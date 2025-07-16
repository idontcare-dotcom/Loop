import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';

class OptimizedScoreCelebrationWidget extends StatefulWidget {
  final String scoreType;
  final int score;
  final int par;
  final VoidCallback? onAnimationComplete;

  const OptimizedScoreCelebrationWidget({
    super.key,
    required this.scoreType,
    required this.score,
    required this.par,
    this.onAnimationComplete,
  });

  @override
  State<OptimizedScoreCelebrationWidget> createState() =>
      _OptimizedScoreCelebrationWidgetState();
}

class _OptimizedScoreCelebrationWidgetState
    extends State<OptimizedScoreCelebrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _particleController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Primary animation controller
    _primaryController = AnimationController(
      duration: AnimationConfig.getScaledDuration(
          AnimationConfig.celebrationDuration),
      vsync: this,
    );

    // Particle effect controller
    _particleController = AnimationController(
      duration:
          AnimationConfig.getScaledDuration(const Duration(milliseconds: 1500)),
      vsync: this,
    );

    // Pulse effect controller
    _pulseController = AnimationController(
      duration:
          AnimationConfig.getScaledDuration(const Duration(milliseconds: 2000)),
      vsync: this,
    );

    // Scale animation with elastic curve for dramatic effect
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _primaryController,
      curve: const Interval(0.0, 0.6, curve: AnimationConfig.scaleCurve),
    ));

    // Fade animation for smooth entrance/exit
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _primaryController,
      curve: const Interval(0.0, 0.3, curve: AnimationConfig.fadeInCurve),
    ));

    // Rotation animation for dynamic effect
    _rotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _primaryController,
      curve: AnimationConfig.bounceInCurve,
    ));

    // Particle expansion animation
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: AnimationConfig.slideInCurve,
    ));

    // Pulsing background animation
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Color transition animation
    _colorAnimation = ColorTween(
      begin: _getCelebrationColor().withValues(alpha: 0.3),
      end: _getCelebrationColor(),
    ).animate(CurvedAnimation(
      parent: _primaryController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));
  }

  Future<void> _startAnimationSequence() async {
    // Haptic feedback for impact
    HapticFeedback.heavyImpact();

    // Start all animations with staggered timing
    _primaryController.forward();

    await Future.delayed(AnimationConfig.staggerDelay);
    _particleController.forward();

    await Future.delayed(AnimationConfig.staggerDelay);
    _pulseController.repeat(reverse: true);

    // Auto-dismiss after delay
    await Future.delayed(const Duration(milliseconds: 2500));
    await _dismissAnimation();
  }

  Future<void> _dismissAnimation() async {
    await _primaryController.reverse();
    _particleController.stop();
    _pulseController.stop();

    widget.onAnimationComplete?.call();
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _getAnimalImageUrl() {
    switch (widget.scoreType) {
      case 'CONDOR':
        return 'https://images.pexels.com/photos/326900/pexels-photo-326900.jpeg?auto=compress&cs=tinysrgb&w=300';
      case 'ALBATROSS':
        return 'https://images.pexels.com/photos/3601425/pexels-photo-3601425.jpeg?auto=compress&cs=tinysrgb&w=300';
      case 'EAGLE':
        return 'https://images.pixabay.com/photo/2019/06/21/21/23/eagle-4292136_640.jpg';
      case 'BIRDIE':
        return 'https://images.pexels.com/photos/1661179/pexels-photo-1661179.jpeg?auto=compress&cs=tinysrgb&w=300';
      default:
        return 'https://images.pixabay.com/photo/2017/10/20/10/58/elephant-2870777_640.jpg';
    }
  }

  String _getCelebrationText() {
    switch (widget.scoreType) {
      case 'CONDOR':
        return 'INCREDIBLE CONDOR!';
      case 'ALBATROSS':
        return 'AMAZING ALBATROSS!';
      case 'EAGLE':
        return 'FANTASTIC EAGLE!';
      case 'BIRDIE':
        return 'GREAT BIRDIE!';
      default:
        return 'EXCELLENT SHOT!';
    }
  }

  Color _getCelebrationColor() {
    switch (widget.scoreType) {
      case 'CONDOR':
        return AppTheme.birdieColors['condor']!;
      case 'ALBATROSS':
        return AppTheme.birdieColors['albatross']!;
      case 'EAGLE':
        return AppTheme.birdieColors['eagle']!;
      case 'BIRDIE':
        return AppTheme.birdieColors['birdie']!;
      default:
        return AppTheme.birdieColors['birdie']!;
    }
  }

  Widget _buildParticleEffect() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(8, (index) {
            final angle = (index * 45.0) * (3.14159 / 180.0);
            final distance = 40.0 * _particleAnimation.value;
            final opacity = 1.0 - _particleAnimation.value;

            return Positioned(
              left: 50.w - 5 + (distance * cos(angle)),
              top: 35.w - 5 + (distance * sin(angle)),
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _getCelebrationColor(),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getCelebrationColor().withValues(alpha: 0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  double cos(double angle) => (angle == 0)
      ? 1.0
      : (angle == 1.5708)
          ? 0.0
          : (angle == 3.14159)
              ? -1.0
              : (angle == 4.71239)
                  ? 0.0
                  : 1.0 -
                      (angle * angle / 2) +
                      (angle * angle * angle * angle / 24);

  double sin(double angle) => (angle == 0)
      ? 0.0
      : (angle == 1.5708)
          ? 1.0
          : (angle == 3.14159)
              ? 0.0
              : (angle == 4.71239)
                  ? -1.0
                  : angle -
                      (angle * angle * angle / 6) +
                      (angle * angle * angle * angle * angle / 120);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _fadeAnimation,
        _rotationAnimation,
        _pulseAnimation,
        _colorAnimation
      ]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Stack(
                children: [
                  // Pulsing background glow
                  Positioned.fill(
                    child: Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _colorAnimation.value?.withValues(alpha: 0.2) ??
                                  Colors.transparent,
                              Colors.transparent,
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Particle effects
                  _buildParticleEffect(),

                  // Main celebration content
                  Container(
                    padding: EdgeInsets.all(6.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Enhanced animal image with glow effect
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                _colorAnimation.value?.withValues(alpha: 0.8) ??
                                    Colors.transparent,
                                _colorAnimation.value ?? Colors.transparent,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _colorAnimation.value
                                        ?.withValues(alpha: 0.4) ??
                                    Colors.transparent,
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: _colorAnimation.value
                                        ?.withValues(alpha: 0.2) ??
                                    Colors.transparent,
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipOval(
                              child: CustomImageWidget(
                                imageUrl: _getAnimalImageUrl(),
                                width: 30.w,
                                height: 30.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Enhanced celebration text with gradient
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _colorAnimation.value?.withValues(alpha: 0.1) ??
                                    Colors.transparent,
                                _colorAnimation.value?.withValues(alpha: 0.2) ??
                                    Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color:
                                  _colorAnimation.value ?? Colors.transparent,
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _colorAnimation.value
                                        ?.withValues(alpha: 0.3) ??
                                    Colors.transparent,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                _colorAnimation.value ?? Colors.transparent,
                                _colorAnimation.value?.withValues(alpha: 0.8) ??
                                    Colors.transparent,
                              ],
                            ).createShader(bounds),
                            child: Text(
                              _getCelebrationText(),
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: _colorAnimation.value
                                            ?.withValues(alpha: 0.5) ??
                                        Colors.transparent,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),

                        // Enhanced score display
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color:
                                _colorAnimation.value?.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: _colorAnimation.value
                                      ?.withValues(alpha: 0.5) ??
                                  Colors.transparent,
                            ),
                          ),
                          child: Text(
                            '${widget.score} on Par ${widget.par}',
                            style: AppTheme.dataTextStyle(
                              isLight: true,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ).copyWith(
                              color: _colorAnimation.value,
                            ),
                          ),
                        ),
                      ],
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
}
