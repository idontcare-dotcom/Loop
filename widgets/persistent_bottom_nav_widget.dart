import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import './custom_icon_widget.dart';

class PersistentBottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PersistentBottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                iconName: 'home',
                label: 'Home',
                isSelected: currentIndex == 0,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                iconName: 'schedule',
                label: 'Schedule',
                isSelected: currentIndex == 1,
              ),
              _buildNavItem(
                context: context,
                index: 2,
                iconName: 'sports_golf',
                label: 'Play',
                isSelected: currentIndex == 2,
              ),
              _buildNavItem(
                context: context,
                index: 3,
                iconName: 'leaderboard',
                label: 'Leaderboard',
                isSelected: currentIndex == 3,
              ),
              _buildNavItem(
                context: context,
                index: 4,
                iconName: 'person',
                label: 'Profile',
                isSelected: currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String iconName,
    required String label,
    required bool isSelected,
  }) {
    final color = isSelected
        ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
        : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0.5.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: isSelected ? 26 : 24,
              ),
              SizedBox(height: 0.3.h),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: isSelected ? 10.sp : 9.sp,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
