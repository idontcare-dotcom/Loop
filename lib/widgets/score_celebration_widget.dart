import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';

class ScoreCelebrationWidget extends StatefulWidget {
  final String scoreType;
  final int score;
  final int par;
  final VoidCallback? onAnimationComplete;

  const ScoreCelebrationWidget({
    super.key,
    required this.scoreType,
    required this.score,
    required this.par,
    this.onAnimationComplete,
  });

  @override
  State<ScoreCelebrationWidget> createState() => _ScoreCelebrationWidgetState();
}

class _ScoreCelebrationWidgetState extends State<ScoreCelebrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));
    await _fadeController.forward();
    if (widget.onAnimationComplete != null) {
      widget.onAnimationComplete!();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  String _getAnimalImageUrl() {
    switch (widget.scoreType) {
      case 'CONDOR':
        return 'https://images.pexels.com/photos/326900/pexels-photo-326900.jpeg?auto=compress&cs=tinysrgb&w=500';
      case 'ALBATROSS':
        return 'https://images.pexels.com/photos/3601425/pexels-photo-3601425.jpeg?auto=compress&cs=tinysrgb&w=500';
      case 'EAGLE':
        return 'https://images.pixabay.com/photo/2019/06/21/21/23/eagle-4292136_640.jpg';
      case 'BIRDIE':
        return 'https://images.pexels.com/photos/1661179/pexels-photo-1661179.jpeg?auto=compress&cs=tinysrgb&w=500';
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _fadeAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.all(6.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animal Image
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getCelebrationColor(),
                        width: 4.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getCelebrationColor().withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
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
                  SizedBox(height: 3.h),

                  // Celebration Text
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: _getCelebrationColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: _getCelebrationColor(),
                        width: 2.0,
                      ),
                    ),
                    child: Text(
                      _getCelebrationText(),
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: _getCelebrationColor(),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Score Display
                  Text(
                    '${widget.score} on Par ${widget.par}',
                    style: AppTheme.dataTextStyle(
                      isLight: true,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ).copyWith(
                      color: _getCelebrationColor(),
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
