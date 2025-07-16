import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/liquid_glass_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class LiquidGlassBottomNavWidget extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const LiquidGlassBottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<LiquidGlassBottomNavWidget> createState() =>
      _LiquidGlassBottomNavWidgetState();
}

class _LiquidGlassBottomNavWidgetState extends State<LiquidGlassBottomNavWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LiquidGlassBottomNavWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animationController.forward().then((_) {
        _animationController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(4.w, 0, 4.w, 3.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: LiquidGlassTheme.blurIntensityHigh,
            sigmaY: LiquidGlassTheme.blurIntensityHigh,
          ),
          child: Container(
            height: 10.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  LiquidGlassTheme.glassWhite.withAlpha(77),
                  LiquidGlassTheme.glassWhite.withAlpha(26),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: LiquidGlassTheme.glassWhite.withAlpha(102),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: LiquidGlassTheme.glassBlack.withAlpha(26),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
                BoxShadow(
                  color: LiquidGlassTheme.glassWhite.withAlpha(204),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, 'home', 'Home'),
                _buildNavItem(1, 'schedule', 'Schedule'),
                _buildNavItem(2, 'sports_golf', 'Play'),
                _buildNavItem(3, 'leaderboard', 'Leaderboard'),
                _buildNavItem(4, 'person', 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconName, String label) {
    final isSelected = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final scale = isSelected ? 1.0 + (_animation.value * 0.2) : 1.0;

          return Transform.scale(
            scale: scale,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          LiquidGlassTheme.glassPrimary.withAlpha(77),
                          LiquidGlassTheme.glassPrimary.withAlpha(26),
                        ],
                      )
                    : null,
                border: isSelected
                    ? Border.all(
                        color: LiquidGlassTheme.glassPrimary.withAlpha(128),
                        width: 1.0,
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: LiquidGlassTheme.glassPrimary.withAlpha(77),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: isSelected
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                LiquidGlassTheme.glassPrimary.withAlpha(102),
                                LiquidGlassTheme.glassPrimary.withAlpha(51),
                              ],
                            ),
                            border: Border.all(
                              color:
                                  LiquidGlassTheme.glassPrimary.withAlpha(153),
                              width: 1.0,
                            ),
                          )
                        : null,
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: isSelected
                          ? LiquidGlassTheme.glassPrimary
                          : LiquidGlassTheme.glassBlack.withAlpha(153),
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    label,
                    style: LiquidGlassTheme.glassTextStyle(
                      fontSize: 10,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? LiquidGlassTheme.glassPrimary
                          : LiquidGlassTheme.glassBlack.withAlpha(153),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
