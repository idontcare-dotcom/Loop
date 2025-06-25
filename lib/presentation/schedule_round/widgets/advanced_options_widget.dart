import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedOptionsWidget extends StatefulWidget {
  final String selectedFormat;
  final bool useHandicap;
  final bool isPrivate;
  final Function({String? format, bool? handicap, bool? privacy})
      onOptionsChanged;

  const AdvancedOptionsWidget({
    super.key,
    required this.selectedFormat,
    required this.useHandicap,
    required this.isPrivate,
    required this.onOptionsChanged,
  });

  @override
  State<AdvancedOptionsWidget> createState() => _AdvancedOptionsWidgetState();
}

class _AdvancedOptionsWidgetState extends State<AdvancedOptionsWidget> {
  bool isExpanded = false;

  final List<Map<String, dynamic>> gameFormats = [
    {
      "name": "Stroke Play",
      "description": "Traditional scoring - count every stroke",
      "icon": "golf_course",
    },
    {
      "name": "Match Play",
      "description": "Hole-by-hole competition",
      "icon": "sports_golf",
    },
    {
      "name": "Skins",
      "description": "Win money on each hole",
      "icon": "attach_money",
    },
    {
      "name": "Best Ball",
      "description": "Team format - best score per hole",
      "icon": "group",
    },
    {
      "name": "Scramble",
      "description": "Team format - everyone plays best shot",
      "icon": "group_work",
    },
  ];

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _selectFormat(String format) {
    widget.onOptionsChanged(format: format);
  }

  void _toggleHandicap(bool value) {
    widget.onOptionsChanged(handicap: value);
  }

  void _togglePrivacy(bool value) {
    widget.onOptionsChanged(privacy: value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Header - always visible
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'tune',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Advanced Options',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.textMediumEmphasisLight,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: AppTheme.dividerLight,
                          thickness: 1,
                        ),

                        SizedBox(height: 2.h),

                        // Game Format Selection
                        Text(
                          'Game Format',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),

                        ...gameFormats.map((format) {
                          final isSelected =
                              widget.selectedFormat == format["name"];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: InkWell(
                              onTap: () =>
                                  _selectFormat(format["name"] as String),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                          .withOpacity(0.1)
                                      : AppTheme.lightTheme.colorScheme.surface
                                          .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme.dividerLight,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: format["icon"] as String,
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                          : AppTheme.textMediumEmphasisLight,
                                      size: 20,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            format["name"] as String,
                                            style: AppTheme
                                                .lightTheme.textTheme.bodyMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: isSelected
                                                  ? AppTheme.lightTheme
                                                      .colorScheme.primary
                                                  : null,
                                            ),
                                          ),
                                          Text(
                                            format["description"] as String,
                                            style: AppTheme
                                                .lightTheme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: isSelected
                                                  ? AppTheme.lightTheme
                                                      .colorScheme.primary
                                                  : AppTheme
                                                      .textMediumEmphasisLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      CustomIconWidget(
                                        iconName: 'check_circle',
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                        SizedBox(height: 3.h),

                        // Handicap Settings
                        Text(
                          'Scoring Settings',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),

                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.dividerLight,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'trending_up',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 20,
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Use Handicaps',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Calculate net scores for fair competition',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme
                                                .textMediumEmphasisLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: widget.useHandicap,
                                    onChanged: _toggleHandicap,
                                    activeColor:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Privacy Settings
                        Text(
                          'Privacy Settings',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),

                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.dividerLight,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: widget.isPrivate ? 'lock' : 'public',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Private Round',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      widget.isPrivate
                                          ? 'Only invited friends can see this round'
                                          : 'Round visible to all friends',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.textMediumEmphasisLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: widget.isPrivate,
                                onChanged: _togglePrivacy,
                                activeColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Summary of selected options
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withOpacity(0.2),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'summarize',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 16,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Round Summary',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                '${widget.selectedFormat} • ${widget.useHandicap ? 'Net' : 'Gross'} Scoring • ${widget.isPrivate ? 'Private' : 'Public'}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
