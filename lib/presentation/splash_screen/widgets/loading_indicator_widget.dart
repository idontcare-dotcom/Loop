import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatefulWidget {
  final bool isVisible;
  final double size;
  final Color? color;

  const LoadingIndicatorWidget({
    super.key,
    required this.isVisible,
    required this.size,
    this.color,
  });

  @override
  State<LoadingIndicatorWidget> createState() => _LoadingIndicatorWidgetState();
}

class _LoadingIndicatorWidgetState extends State<LoadingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.isVisible) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(LoadingIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: GolfLoadingPainter(
                progress: _animation.value,
                color: widget.color ?? Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}

class GolfLoadingPainter extends CustomPainter {
  final double progress;
  final Color color;

  GolfLoadingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final Paint activePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2 - 2;

    // Draw background circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      paint,
    );

    // Draw progress arc
    final double sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -3.14159 / 2, // Start from top
      sweepAngle,
      false,
      activePaint,
    );

    // Draw golf ball at the end of progress
    if (progress > 0) {
      final double ballX =
          centerX + radius * 0.8 * (progress * 2 - 1).clamp(-1.0, 1.0);
      final double ballY = centerY +
          radius *
              0.8 *
              (1 - progress * 2).abs().clamp(0.0, 1.0) *
              (progress < 0.5 ? -1 : 1);

      final Paint ballPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(ballX, ballY),
        4.0,
        ballPaint,
      );

      // Add golf ball dimples
      final Paint dimplePaint = Paint()
        ..color = color.withOpacity(0.5)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(ballX - 1, ballY - 1), 0.5, dimplePaint);
      canvas.drawCircle(Offset(ballX + 1, ballY - 1), 0.5, dimplePaint);
      canvas.drawCircle(Offset(ballX, ballY + 1), 0.5, dimplePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is GolfLoadingPainter &&
        oldDelegate.progress != progress;
  }
}
