import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/liquid_glass_theme.dart';

/// A reusable glass morphism card widget with liquid glass effects
class GlassCardWidget extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool elevated;
  final bool enableHoverEffect;
  final bool enablePressEffect;
  final Color? backgroundColor;
  final Gradient? gradient;

  const GlassCardWidget({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 24.0,
    this.onTap,
    this.elevated = true,
    this.enableHoverEffect = true,
    this.enablePressEffect = true,
    this.backgroundColor,
    this.gradient,
  });

  @override
  State<GlassCardWidget> createState() => _GlassCardWidgetState();
}

class _GlassCardWidgetState extends State<GlassCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _pressAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _hoverAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));

    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    if (widget.enableHoverEffect) {
      setState(() => _isHovered = true);
      _hoverController.forward();
    }
  }

  void _onHoverExit() {
    if (widget.enableHoverEffect) {
      setState(() => _isHovered = false);
      _hoverController.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enablePressEffect) {
      setState(() => _isPressed = true);
      _pressController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.enablePressEffect) {
      setState(() => _isPressed = false);
      _pressController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.enablePressEffect) {
      setState(() => _isPressed = false);
      _pressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_hoverAnimation, _pressAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pressAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            child: MouseRegion(
              onEnter: (_) => _onHoverEnter(),
              onExit: (_) => _onHoverExit(),
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                onTap: widget.onTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: LiquidGlassTheme.blurIntensityHigh +
                          (_hoverAnimation.value * 8),
                      sigmaY: LiquidGlassTheme.blurIntensityHigh +
                          (_hoverAnimation.value * 8),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        gradient: widget.gradient ??
                            LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                (widget.backgroundColor ??
                                        LiquidGlassTheme.glassWhite)
                                    .withOpacity(
                                        0.25 + (_hoverAnimation.value * 0.1)),
                                (widget.backgroundColor ??
                                        LiquidGlassTheme.glassWhite)
                                    .withOpacity(
                                        0.05 + (_hoverAnimation.value * 0.05)),
                              ],
                            ),
                        border: Border.all(
                          color: LiquidGlassTheme.glassWhite
                              .withOpacity(0.3 + (_hoverAnimation.value * 0.2)),
                          width: 1.5,
                        ),
                        boxShadow: widget.elevated
                            ? [
                                BoxShadow(
                                  color: LiquidGlassTheme.glassBlack
                                      .withOpacity(
                                          0.15 + (_hoverAnimation.value * 0.1)),
                                  blurRadius: 32 + (_hoverAnimation.value * 16),
                                  offset: Offset(
                                      0, 16 + (_hoverAnimation.value * 8)),
                                ),
                                BoxShadow(
                                  color: LiquidGlassTheme.glassWhite
                                      .withOpacity(
                                          0.9 + (_hoverAnimation.value * 0.1)),
                                  blurRadius: 2 + (_hoverAnimation.value * 2),
                                  offset: const Offset(0, 2),
                                ),
                                if (_isHovered)
                                  BoxShadow(
                                    color: LiquidGlassTheme.glassWhite
                                        .withOpacity(
                                            0.6 * _hoverAnimation.value),
                                    blurRadius: 24 * _hoverAnimation.value,
                                    offset: const Offset(0, 0),
                                  ),
                              ]
                            : null,
                      ),
                      child: Container(
                        padding: widget.padding ?? EdgeInsets.all(4.w),
                        child: widget.child,
                      ),
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
