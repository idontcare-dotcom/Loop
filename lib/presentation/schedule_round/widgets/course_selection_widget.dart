import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CourseSelectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> courses;
  final Map<String, dynamic>? selectedCourse;
  final Function(Map<String, dynamic>) onCourseSelected;

  const CourseSelectionWidget({
    super.key,
    required this.courses,
    this.selectedCourse,
    required this.onCourseSelected,
  });

  @override
  State<CourseSelectionWidget> createState() => _CourseSelectionWidgetState();
}

class _CourseSelectionWidgetState extends State<CourseSelectionWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCourses = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredCourses = widget.courses;
  }

  void _filterCourses(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCourses = widget.courses;
        isSearching = false;
      } else {
        isSearching = true;
        filteredCourses = widget.courses.where((course) {
          final name = (course["name"] as String).toLowerCase();
          final location = (course["location"] as String).toLowerCase();
          return name.contains(query.toLowerCase()) ||
              location.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _showCourseSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Text(
                    'Select Golf Course',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: TextField(
                controller: _searchController,
                onChanged: _filterCourses,
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  prefixIcon: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 20,
                  ),
                  suffixIcon: CustomIconWidget(
                    iconName: 'gps_fixed',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Course list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = filteredCourses[index];
                  return _buildCourseCard(course);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () {
          widget.onCourseSelected(course);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              // Course image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomImageWidget(
                  imageUrl: course["image"] as String,
                  width: 20.w,
                  height: 15.w,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 3.w),

              // Course details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course["name"] as String,
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.textMediumEmphasisLight,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            course["location"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'directions_walk',
                          color: AppTheme.textMediumEmphasisLight,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          course["distance"] as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        SizedBox(width: 3.w),
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.warningLight,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          course["rating"].toString(),
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${course["greenFee"].toStringAsFixed(0)}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'per person',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _showCourseSelection,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'golf_course',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Golf Course',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  CustomIconWidget(
                    iconName: 'keyboard_arrow_right',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 24,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              widget.selectedCourse != null
                  ? Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageWidget(
                            imageUrl: widget.selectedCourse!["image"] as String,
                            width: 15.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.selectedCourse!["name"] as String,
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                widget.selectedCourse!["location"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${widget.selectedCourse!["greenFee"].toStringAsFixed(0)}',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 3.h),
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
                          CustomIconWidget(
                            iconName: 'add_location',
                            color: AppTheme.textMediumEmphasisLight,
                            size: 32,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Tap to select a golf course',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textMediumEmphasisLight,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
