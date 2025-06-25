import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LogoAnimationWidget extends StatefulWidget {
  final double size;
  final bool isAnimating;

  const LogoAnimationWidget({
    super.key,
    required this.size,
    this.isAnimating = true,
  });

  @override
  State<LogoAnimationWidget> createState() => _LogoAnimationWidgetState();
}

class _LogoAnimationWidgetState extends State<LogoAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.isAnimating) {
      _startAnimations();
    }
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void didUpdateWidget(LogoAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _startAnimations();
      } else {
        _pulseController.stop();
        _rotationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _rotationController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 0.1, // Subtle rotation
            child: _buildLogoContent(),
          ),
        );
      },
    );
  }

  Widget _buildLogoContent() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white,
            Colors.white.withValues(alpha: 0.9),
            Colors.white.withValues(alpha: 0.7),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildGolfBallPattern(),
          _buildLogoIcon(),
        ],
      ),
    );
  }

  Widget _buildGolfBallPattern() {
    return CustomPaint(
      size: Size(widget.size * 0.8, widget.size * 0.8),
      painter: GolfBallPatternPainter(),
    );
  }

  Widget _buildLogoIcon() {
    return Container(
      width: widget.size * 0.6,
      height: widget.size * 0.6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.lightTheme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomIconWidget(
        iconName: 'sports_golf',
        color: Colors.white,
        size: widget.size * 0.3,
      ),
    );
  }
}

class GolfBallPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    // Create golf ball dimple pattern
    final List<Offset> dimplePositions = [
      Offset(centerX - radius * 0.3, centerY - radius * 0.3),
      Offset(centerX + radius * 0.3, centerY - radius * 0.3),
      Offset(centerX - radius * 0.3, centerY + radius * 0.3),
      Offset(centerX + radius * 0.3, centerY + radius * 0.3),
      Offset(centerX, centerY - radius * 0.4),
      Offset(centerX, centerY + radius * 0.4),
      Offset(centerX - radius * 0.4, centerY),
      Offset(centerX + radius * 0.4, centerY),
    ];

    for (final position in dimplePositions) {
      canvas.drawCircle(position, 2.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
