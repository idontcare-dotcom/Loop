import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CostCalculationWidget extends StatelessWidget {
  final Map<String, dynamic>? selectedCourse;
  final List<Map<String, dynamic>> selectedFriends;
  final double totalCost;

  const CostCalculationWidget({
    super.key,
    this.selectedCourse,
    required this.selectedFriends,
    required this.totalCost,
  });

  double get costPerPerson {
    final participantCount = selectedFriends.length + 1; // +1 for current user
    return participantCount > 0 ? totalCost / participantCount : 0.0;
  }

  int get participantCount => selectedFriends.length + 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'attach_money',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Cost Breakdown',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 3.h),
            if (selectedCourse != null) ...[
              // Course fee breakdown
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.dividerLight,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Green Fee',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        Text(
                          '\$${(selectedCourse!["greenFee"] as double).toStringAsFixed(0)}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Participants',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        Text(
                          '$participantCount players',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Divider(
                      color: AppTheme.dividerLight,
                      thickness: 1,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Cost',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$${totalCost.toStringAsFixed(0)}',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Cost per person highlight
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '\$${costPerPerson.toStringAsFixed(0)}',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'per person',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              if (selectedFriends.isNotEmpty) ...[
                SizedBox(height: 2.h),

                // Participant list
                Text(
                  'Cost Split',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),

                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Current user
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            radius: 16,
                            child: CustomIconWidget(
                              iconName: 'person',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'You',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '\$${costPerPerson.toStringAsFixed(0)}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // Selected friends
                      ...selectedFriends.map((friend) {
                        return Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(friend["avatar"] as String),
                                radius: 16,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  friend["name"] as String,
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              ),
                              Text(
                                '\$${costPerPerson.toStringAsFixed(0)}',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ] else ...[
              // No course selected state
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.dividerLight,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'calculate',
                      color: AppTheme.textMediumEmphasisLight,
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Select a course to see cost breakdown',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
