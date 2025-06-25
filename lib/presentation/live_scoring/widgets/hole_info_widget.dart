import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HoleInfoWidget extends StatelessWidget {
  final int hole;
  final int par;
  final int yardage;
  final int distanceToPin;

  const HoleInfoWidget({
    super.key,
    required this.hole,
    required this.par,
    required this.yardage,
    required this.distanceToPin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'HOLE',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary
                  .withOpacity(0.8),
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            '$hole',
            style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontSize: 48.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem(
                icon: 'flag',
                label: 'PAR',
                value: '$par',
                context: context,
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withOpacity(0.3),
              ),
              _buildInfoItem(
                icon: 'straighten',
                label: 'YARDS',
                value: '$yardage',
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color:
              AppTheme.lightTheme.colorScheme.onPrimary.withOpacity(0.8),
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary
                .withOpacity(0.8),
            letterSpacing: 1.0,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.dataTextStyle(
            isLight: true,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ).copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
