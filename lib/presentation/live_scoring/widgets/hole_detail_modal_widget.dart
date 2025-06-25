import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HoleDetailModalWidget extends StatefulWidget {
  final int hole;
  final int par;
  final int currentScore;
  final Function(int) onScoreUpdate;

  const HoleDetailModalWidget({
    super.key,
    required this.hole,
    required this.par,
    required this.currentScore,
    required this.onScoreUpdate,
  });

  @override
  State<HoleDetailModalWidget> createState() => _HoleDetailModalWidgetState();
}

class _HoleDetailModalWidgetState extends State<HoleDetailModalWidget> {
  late int selectedScore;
  int penalties = 0;
  int putts = 2;
  bool fairwayHit = false;
  bool greenInRegulation = false;

  @override
  void initState() {
    super.initState();
    selectedScore = widget.currentScore > 0 ? widget.currentScore : widget.par;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 80.h,
          maxWidth: 90.w,
        ),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.dialogBackgroundColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hole ${widget.hole} Details',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Score',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      height: 8.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          final score = widget.par - 2 + index;
                          final isSelected = selectedScore == score;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedScore = score;
                              });
                              HapticFeedback.lightImpact();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.w),
                              width: 16.w,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.cardColor,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.dividerColor,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$score',
                                  style: AppTheme.dataTextStyle(
                                    isLight: true,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ).copyWith(
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.onPrimary
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Additional Stats',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 2.h),
                    _buildStatRow(
                      'Penalties',
                      penalties,
                      (value) => setState(() => penalties = value),
                    ),
                    SizedBox(height: 2.h),
                    _buildStatRow(
                      'Putts',
                      putts,
                      (value) => setState(() => putts = value),
                    ),
                    SizedBox(height: 2.h),
                    _buildSwitchRow(
                      'Fairway Hit',
                      fairwayHit,
                      (value) => setState(() => fairwayHit = value),
                    ),
                    SizedBox(height: 2.h),
                    _buildSwitchRow(
                      'Green in Regulation',
                      greenInRegulation,
                      (value) => setState(() => greenInRegulation = value),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: AppTheme.lightTheme.textTheme.labelLarge,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onScoreUpdate(selectedScore);
                              Navigator.pop(context);
                              HapticFeedback.mediumImpact();
                            },
                            child: Text(
                              'Save',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        Row(
          children: [
            IconButton(
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
              icon: CustomIconWidget(
                iconName: 'remove_circle_outline',
                color: value > 0
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                size: 24,
              ),
            ),
            Container(
              width: 12.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                ),
              ),
              child: Center(
                child: Text(
                  '$value',
                  style: AppTheme.dataTextStyle(
                    isLight: true,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => onChanged(value + 1),
              icon: CustomIconWidget(
                iconName: 'add_circle_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
