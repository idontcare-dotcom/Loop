import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/liquid_glass_theme.dart';

class LiquidGlassGreetingWidget extends StatelessWidget {
  final String userName;
  final String location;
  final String weather;

  const LiquidGlassGreetingWidget({
    super.key,
    required this.userName,
    required this.location,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = _getGreeting(hour);
    final greetingIcon = _getGreetingIcon(hour);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: GlassCardWidget(
        borderRadius: 32.0,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            LiquidGlassTheme.glassAccent.withAlpha(26),
            LiquidGlassTheme.glassWhite.withAlpha(38),
            LiquidGlassTheme.glassPrimary.withAlpha(20),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        LiquidGlassTheme.glassAccent.withAlpha(77),
                        LiquidGlassTheme.glassAccent.withAlpha(26),
                      ],
                    ),
                    border: Border.all(
                      color: LiquidGlassTheme.glassAccent.withAlpha(128),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: LiquidGlassTheme.glassAccent.withAlpha(77),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CustomIconWidget(
                    iconName: greetingIcon,
                    color: LiquidGlassTheme.glassAccent,
                    size: 24,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: LiquidGlassTheme.glassTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: LiquidGlassTheme.glassBlack.withAlpha(179),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        userName,
                        style: LiquidGlassTheme.glassTextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: LiquidGlassTheme.glassBlack.withAlpha(230),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        LiquidGlassTheme.glassWhite.withAlpha(102),
                        LiquidGlassTheme.glassWhite.withAlpha(26),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: LiquidGlassTheme.glassWhite.withAlpha(153),
                      width: 1.0,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'notifications',
                    color: LiquidGlassTheme.glassBlack.withAlpha(153),
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    LiquidGlassTheme.glassSecondary.withAlpha(31),
                    LiquidGlassTheme.glassSecondary.withAlpha(10),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: LiquidGlassTheme.glassSecondary.withAlpha(77),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          LiquidGlassTheme.glassSecondary.withAlpha(77),
                          LiquidGlassTheme.glassSecondary.withAlpha(26),
                        ],
                      ),
                      border: Border.all(
                        color: LiquidGlassTheme.glassSecondary.withAlpha(128),
                        width: 1.0,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'location_on',
                      color: LiquidGlassTheme.glassSecondary,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location,
                          style: LiquidGlassTheme.glassTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: LiquidGlassTheme.glassBlack.withAlpha(204),
                          ),
                        ),
                        Text(
                          weather,
                          style: LiquidGlassTheme.glassTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: LiquidGlassTheme.glassBlack.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.withAlpha(77),
                          Colors.orange.withAlpha(26),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.orange.withAlpha(128),
                        width: 1.0,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'wb_sunny',
                      color: Colors.orange,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  String _getGreetingIcon(int hour) {
    if (hour < 12) {
      return 'wb_sunny';
    } else if (hour < 17) {
      return 'wb_sunny';
    } else {
      return 'nights_stay';
    }
  }
}
