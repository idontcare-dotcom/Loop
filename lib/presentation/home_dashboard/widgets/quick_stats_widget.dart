import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickStatsWidget extends StatelessWidget {
  final double handicap;
  final double recentAverage;
  final String improvementTrend;
  final VoidCallback onTap;

  const QuickStatsWidget({
    super.key,
    required this.handicap,
    required this.recentAverage,
    required this.improvementTrend,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isImprovement = improvementTrend.startsWith('+');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Card(
        elevation: 2,
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Quick Stats',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    CustomIconWidget(
                      iconName: 'trending_up',
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        'Handicap',
                        handicap.toString(),
                        Icons.golf_course,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 6.h,
                      color: Theme.of(context).dividerColor,
                    ),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        'Recent Avg',
                        recentAverage.toStringAsFixed(1),
                        Icons.analytics,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 6.h,
                      color: Theme.of(context).dividerColor,
                    ),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        'Trend',
                        improvementTrend,
                        isImprovement ? Icons.trending_up : Icons.trending_down,
                        valueColor: isImprovement
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tap for detailed analytics',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                      size: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon.toString().split('.').last,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: valueColor ?? Theme.of(context).colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
