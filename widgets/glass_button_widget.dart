import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../theme/app_theme.dart';
import '../theme/liquid_glass_theme.dart';

/// A glass morphism button widget with dynamic lighting effects
class GlassButtonWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final bool isPrimary;
  final bool isOutlined;
  final bool enableHapticFeedback;

  const GlassButtonWidget({
    super.key,
    required this.child,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.isPrimary = false,
    this.isOutlined = false,
    this.enableHapticFeedback = true,
  });

  @override
  State<GlassButtonWidget> createState() => _GlassButtonWidgetState();
}

class _GlassButtonWidgetState extends State<GlassButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _lightController;
  late Animation<double> _pressAnimation;
  late Animation<double> _lightAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _lightController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    _lightAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _lightController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _pressController.dispose();
    _lightController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _pressController.forward();
    _lightController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _pressController.reverse();
    _lightController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
    _lightController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ??
        (widget.isPrimary
            ? AppTheme.primaryBackground // Use #2F3130 as default primary
            : LiquidGlassTheme.glassWhite);

    return AnimatedBuilder(
      animation: Listenable.merge([_pressAnimation, _lightAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pressAnimation.value,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: LiquidGlassTheme.blurIntensityMedium,
                    sigmaY: LiquidGlassTheme.blurIntensityMedium,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      gradient: widget.isOutlined
                          ? null
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                bgColor.withOpacity(
                                    0.3 + (_lightAnimation.value * 0.2)),
                                bgColor.withOpacity(
                                    0.1 + (_lightAnimation.value * 0.1)),
                              ],
                            ),
                      border: Border.all(
                        color: bgColor.withOpacity(widget.isOutlined
                            ? 0.6
                            : 0.4 + (_lightAnimation.value * 0.2)),
                        width: widget.isOutlined ? 2.0 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: bgColor
                              .withOpacity(0.2 + (_lightAnimation.value * 0.3)),
                          blurRadius: 16 + (_lightAnimation.value * 12),
                          offset: Offset(0, 8 + (_lightAnimation.value * 4)),
                        ),
                        if (_isPressed)
                          BoxShadow(
                            color: LiquidGlassTheme.glassWhite
                                .withOpacity(0.8 * _lightAnimation.value),
                            blurRadius: 20 * _lightAnimation.value,
                            offset: const Offset(0, 0),
                          ),
                      ],
                    ),
                    child: Container(
                      padding: widget.padding ??
                          EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                      child: Center(child: widget.child),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
