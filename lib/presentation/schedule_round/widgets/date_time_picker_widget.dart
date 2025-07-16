import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DateTimePickerWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final Function(DateTime, TimeOfDay) onDateTimeSelected;

  const DateTimePickerWidget({
    super.key,
    this.selectedDate,
    this.selectedTime,
    required this.onDateTimeSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (selectedTime != null) {
        onDateTimeSelected(picked, selectedTime!);
      } else {
        // Auto-select a default time if none selected
        const defaultTime = TimeOfDay(hour: 9, minute: 0);
        onDateTimeSelected(picked, defaultTime);
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (selectedDate != null) {
        onDateTimeSelected(selectedDate!, picked);
      } else {
        // Auto-select tomorrow if no date selected
        final defaultDate = DateTime.now().add(const Duration(days: 1));
        onDateTimeSelected(defaultDate, picked);
      }
    }
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];

    return '$weekday, $month ${date.day}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

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
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Date & Time',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                // Date picker
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: selectedDate != null
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedDate != null
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.dividerLight,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'calendar_today',
                            color: selectedDate != null
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.textMediumEmphasisLight,
                            size: 28,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            selectedDate != null
                                ? _formatDate(selectedDate!)
                                : 'Select Date',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: selectedDate != null
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.textMediumEmphasisLight,
                              fontWeight: selectedDate != null
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Time picker
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: selectedTime != null
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedTime != null
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.dividerLight,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: selectedTime != null
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.textMediumEmphasisLight,
                            size: 28,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            selectedTime != null
                                ? _formatTime(selectedTime!)
                                : 'Select Time',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: selectedTime != null
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.textMediumEmphasisLight,
                              fontWeight: selectedTime != null
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (selectedDate != null && selectedTime != null) ...[
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.successLight.withValues(alpha: 0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.successLight,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Tee time: ${_formatDate(selectedDate!)} at ${_formatTime(selectedTime!)}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successLight,
                        fontWeight: FontWeight.w500,
                      ),
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
