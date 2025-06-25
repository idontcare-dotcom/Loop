import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementBadgesWidget({
    super.key,
    required this.achievements,
  });

  void _showAchievementDetails(
      BuildContext context, Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: achievement["unlocked"] as bool
                    ? AppTheme.accentLight.withValues(alpha: 0.1)
                    : AppTheme.textDisabledLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: achievement["icon"] as String,
                color: achievement["unlocked"] as bool
                    ? AppTheme.accentLight
                    : AppTheme.textDisabledLight,
                size: 32,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              achievement["title"] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              achievement["description"] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (achievement["unlocked"] as bool) ...[
              SizedBox(height: 1.h),
              Text(
                'Unlocked on ${achievement["date"]}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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

  Widget _buildAchievementBadge(Map<String, dynamic> achievement) {
    final bool isUnlocked = achievement["unlocked"] as bool;

    return GestureDetector(
      onTap: () => _showAchievementDetails(null as BuildContext, achievement),
      child: Container(
        width: 20.w,
        margin: EdgeInsets.only(right: 3.w),
        child: Column(
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppTheme.accentLight.withValues(alpha: 0.1)
                    : AppTheme.textDisabledLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUnlocked
                      ? AppTheme.accentLight
                      : AppTheme.textDisabledLight,
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: achievement["icon"] as String,
                color: isUnlocked
                    ? AppTheme.accentLight
                    : AppTheme.textDisabledLight,
                size: 24,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              achievement["title"] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: isUnlocked
                    ? AppTheme.textHighEmphasisLight
                    : AppTheme.textDisabledLight,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all achievements
                },
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 20.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                return Builder(
                  builder: (context) {
                    final achievement = achievements[index];
                    return GestureDetector(
                      onTap: () =>
                          _showAchievementDetails(context, achievement),
                      child: _buildAchievementBadge(achievement),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
