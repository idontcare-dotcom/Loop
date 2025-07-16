import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/liquid_glass_theme.dart';

class LiquidGlassStatsWidget extends StatelessWidget {
  final double handicap;
  final double recentAverage;
  final String improvementTrend;
  final VoidCallback onTap;

  const LiquidGlassStatsWidget({
    super.key,
    required this.handicap,
    required this.recentAverage,
    required this.improvementTrend,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: GlassCardWidget(
        onTap: onTap,
        borderRadius: 24.0,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            LiquidGlassTheme.glassSecondary.withAlpha(31),
            LiquidGlassTheme.glassWhite.withAlpha(20),
            LiquidGlassTheme.glassAccent.withAlpha(15),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        LiquidGlassTheme.glassSecondary.withAlpha(77),
                        LiquidGlassTheme.glassSecondary.withAlpha(26),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: LiquidGlassTheme.glassSecondary.withAlpha(102),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    'QUICK STATS',
                    style: LiquidGlassTheme.glassTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: LiquidGlassTheme.glassSecondary,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        LiquidGlassTheme.glassWhite.withAlpha(102),
                        LiquidGlassTheme.glassWhite.withAlpha(26),
                      ],
                    ),
                    border: Border.all(
                      color: LiquidGlassTheme.glassWhite.withAlpha(153),
                      width: 1.0,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'trending_up',
                    color: LiquidGlassTheme.glassSecondary,
                    size: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Handicap',
                    handicap.toString(),
                    LiquidGlassTheme.glassPrimary,
                    'golf_course',
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Recent Avg',
                    recentAverage.toString(),
                    LiquidGlassTheme.glassSecondary,
                    'analytics',
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
                    _getTrendColor().withAlpha(51),
                    _getTrendColor().withAlpha(13),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getTrendColor().withAlpha(102),
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
                          _getTrendColor().withAlpha(77),
                          _getTrendColor().withAlpha(26),
                        ],
                      ),
                      border: Border.all(
                        color: _getTrendColor().withAlpha(128),
                        width: 1.0,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: improvementTrend.startsWith('+')
                          ? 'trending_up'
                          : 'trending_down',
                      color: _getTrendColor(),
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Improvement Trend',
                        style: LiquidGlassTheme.glassTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: LiquidGlassTheme.glassBlack.withAlpha(153),
                        ),
                      ),
                      Text(
                        improvementTrend,
                        style: LiquidGlassTheme.glassTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _getTrendColor(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    String iconName,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withAlpha(38),
            color.withAlpha(13),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withAlpha(77),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  color.withAlpha(77),
                  color.withAlpha(26),
                ],
              ),
              border: Border.all(
                color: color.withAlpha(128),
                width: 1.0,
              ),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: LiquidGlassTheme.glassTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: LiquidGlassTheme.glassBlack.withAlpha(153),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: LiquidGlassTheme.glassTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTrendColor() {
    return improvementTrend.startsWith('+') ? Colors.green : Colors.red;
  }
}
