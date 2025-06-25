import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BackgroundGradientWidget extends StatelessWidget {
  const BackgroundGradientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primaryContainer,
            AppTheme.lightTheme.colorScheme.secondary,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          _buildGolfPatternOverlay(),
          _buildGradientOverlay(),
        ],
      ),
    );
  }

  Widget _buildGolfPatternOverlay() {
    return Positioned.fill(
      child: CustomPaint(
        painter: GolfPatternPainter(),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.1),
            Colors.black.withValues(alpha: 0.3),
            Colors.black.withValues(alpha: 0.1),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

class GolfPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw subtle golf-themed pattern
    final double spacing = size.width * 0.15;

    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        // Draw golf ball dimple pattern
        canvas.drawCircle(
          Offset(x, y),
          2.0,
          paint..style = PaintingStyle.fill,
        );

        // Draw connecting lines
        if (x + spacing < size.width) {
          canvas.drawLine(
            Offset(x + 2, y),
            Offset(x + spacing - 2, y),
            paint..style = PaintingStyle.stroke,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
