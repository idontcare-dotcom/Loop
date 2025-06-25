import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatisticsCardsWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const StatisticsCardsWidget({
    super.key,
    required this.userData,
  });

  void _showDetailedAnalytics(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          '$title Analytics',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed analytics for $title would be displayed here with charts and trends.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'analytics',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 48,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Chart Placeholder',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required String iconName,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconWidget(
                    iconName: iconName,
                    color: iconColor,
                    size: 24,
                  ),
                  CustomIconWidget(
                    iconName: 'expand_more',
                    color: AppTheme.textDisabledLight,
                    size: 16,
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                value,
                style: AppTheme.dataTextStyle(
                  isLight: true,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textDisabledLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),

          // First row of stats
          Row(
            children: [
              _buildStatCard(
                title: 'Rounds Played',
                value: '${userData["roundsPlayed"]}',
                subtitle: 'This season',
                iconName: 'sports_golf',
                iconColor: AppTheme.lightTheme.primaryColor,
                onTap: () => _showDetailedAnalytics(context, 'Rounds Played'),
              ),
              SizedBox(width: 3.w),
              _buildStatCard(
                title: 'Average Score',
                value: '${userData["averageScore"]}',
                subtitle: 'Last 10 rounds',
                iconName: 'trending_up',
                iconColor: AppTheme.secondaryLight,
                onTap: () => _showDetailedAnalytics(context, 'Average Score'),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Second row of stats
          Row(
            children: [
              _buildStatCard(
                title: 'Best Round',
                value: '${userData["bestRound"]}',
                subtitle: 'Personal best',
                iconName: 'emoji_events',
                iconColor: AppTheme.accentLight,
                onTap: () => _showDetailedAnalytics(context, 'Best Round'),
              ),
              SizedBox(width: 3.w),
              _buildStatCard(
                title: 'Improvement',
                value: userData["improvementTrend"] as String,
                subtitle: 'vs last month',
                iconName: 'show_chart',
                iconColor: AppTheme.successLight,
                onTap: () => _showDetailedAnalytics(context, 'Improvement'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
