import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HandicapManagementWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const HandicapManagementWidget({
    super.key,
    required this.userData,
  });

  void _showHandicapHistory(BuildContext context) {
    final List<Map<String, dynamic>> handicapHistory = [
{ "date": "2024-01-15",
"handicap": 12.4,
"change": -0.3,
"source": "GHIN",
"rounds": 5 },
{ "date": "2024-01-01",
"handicap": 12.7,
"change": 0.2,
"source": "Manual",
"rounds": 3 },
{ "date": "2023-12-15",
"handicap": 12.5,
"change": -0.5,
"source": "GHIN",
"rounds": 4 },
];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.textDisabledLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Handicap History',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.separated(
                itemCount: handicapHistory.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppTheme.dividerLight,
                  height: 2.h,
                ),
                itemBuilder: (context, index) {
                  final history = handicapHistory[index];
                  final change = history["change"] as double;
                  
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: change < 0 
                            ? AppTheme.successLight.withOpacity(0.1)
                            : change > 0 
                                ? AppTheme.warningLight.withOpacity(0.1)
                                : AppTheme.textDisabledLight.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: change < 0 
                            ? 'trending_down'
                            : change > 0 
                                ? 'trending_up'
                                : 'trending_flat',
                        color: change < 0 
                            ? AppTheme.successLight
                            : change > 0 
                                ? AppTheme.warningLight
                                : AppTheme.textDisabledLight,
                        size: 20,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          '${history["handicap"]}',
                          style: AppTheme.dataTextStyle(
                            isLight: true,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          change > 0 ? '+$change' : '$change',
                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: change < 0 
                                ? AppTheme.successLight
                                : change > 0 
                                    ? AppTheme.warningLight
                                    : AppTheme.textDisabledLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      '${history["date"]} • ${history["source"]} • ${history["rounds"]} rounds',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateHandicap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Update Handicap',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'New Handicap',
                hintText: 'Enter your handicap',
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Sync with GHIN
                      Navigator.pop(context);
                    },
                    child: const Text('Sync GHIN'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Manual update
                      Navigator.pop(context);
                    },
                    child: const Text('Update'),
                  ),
                ),
              ],
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
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
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
                Text(
                  'Handicap Management',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'sports_golf',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Handicap',
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${userData["handicap"]}',
                        style: AppTheme.dataTextStyle(
                          isLight: true,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: userData["handicapTrend"] == "improving" 
                        ? AppTheme.successLight.withOpacity(0.1)
                        : userData["handicapTrend"] == "declining" 
                            ? AppTheme.warningLight.withOpacity(0.1)
                            : AppTheme.textDisabledLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: userData["handicapTrend"] == "improving" 
                            ? 'trending_down' 
                            : userData["handicapTrend"] == "declining" 
                                ? 'trending_up' 
                                : 'trending_flat',
                        color: userData["handicapTrend"] == "improving" 
                            ? AppTheme.successLight 
                            : userData["handicapTrend"] == "declining" 
                                ? AppTheme.warningLight 
                                : AppTheme.textMediumEmphasisLight,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        userData["handicapTrend"] == "improving" 
                            ? 'Improving'
                            : userData["handicapTrend"] == "declining" 
                                ? 'Declining'
                                : 'Stable',
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: userData["handicapTrend"] == "improving" 
                              ? AppTheme.successLight 
                              : userData["handicapTrend"] == "declining" 
                                  ? AppTheme.warningLight 
                                  : AppTheme.textMediumEmphasisLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showHandicapHistory(context),
                    child: const Text('View History'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateHandicap(context),
                    child: const Text('Update'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}