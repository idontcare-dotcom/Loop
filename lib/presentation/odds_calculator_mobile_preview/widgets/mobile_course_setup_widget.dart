import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../models/course_model.dart';

class MobileCourseSetupWidget extends StatefulWidget {
  final CourseModel? course;
  final Function(CourseModel) onCourseChanged;

  const MobileCourseSetupWidget({
    super.key,
    this.course,
    required this.onCourseChanged,
  });

  @override
  State<MobileCourseSetupWidget> createState() =>
      _MobileCourseSetupWidgetState();
}

class _MobileCourseSetupWidgetState extends State<MobileCourseSetupWidget> {
  final _courseNameController = TextEditingController();
  final _courseRatingController = TextEditingController();
  final _slopeRatingController = TextEditingController();

  String _selectedWeather = 'Clear';
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<Map<String, dynamic>> _weatherOptions = [
    {'name': 'Clear', 'icon': Icons.wb_sunny, 'color': Colors.orange},
    {'name': 'Cloudy', 'icon': Icons.cloud, 'color': Colors.grey},
    {'name': 'Windy', 'icon': Icons.air, 'color': Colors.blue},
    {'name': 'Rainy', 'icon': Icons.umbrella, 'color': Colors.blue.shade700},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      _courseNameController.text = widget.course!.name;
      _courseRatingController.text = widget.course!.courseRating.toString();
      _slopeRatingController.text = widget.course!.slopeRating.toString();
      _selectedWeather = widget.course!.weather;
      _selectedTime = TimeOfDay.fromDateTime(widget.course!.teeTime);
    }
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseRatingController.dispose();
    _slopeRatingController.dispose();
    super.dispose();
  }

  void _updateCourse() {
    HapticFeedback.lightImpact();
    if (_courseNameController.text.isNotEmpty &&
        _courseRatingController.text.isNotEmpty &&
        _slopeRatingController.text.isNotEmpty) {
      final now = DateTime.now();
      final teeTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final course = CourseModel(
        name: _courseNameController.text,
        courseRating: double.tryParse(_courseRatingController.text) ?? 72.0,
        slopeRating: int.tryParse(_slopeRatingController.text) ?? 113,
        weather: _selectedWeather,
        teeTime: teeTime,
      );

      widget.onCourseChanged(course);
    }
  }

  Future<void> _selectTime() async {
    HapticFeedback.mediumImpact();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.accentGreen,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      _updateCourse();
    }
  }

  void _showWeatherSelector() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppTheme.primaryBackground.withAlpha(77),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Text(
                    'Select Weather Conditions',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBackground,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  ..._weatherOptions.map((weather) {
                    final isSelected = _selectedWeather == weather['name'];
                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _selectedWeather = weather['name'];
                          });
                          _updateCourse();
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.accentGreen
                                  : AppTheme.primaryBackground.withAlpha(51),
                              width: isSelected ? 2 : 1,
                            ),
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      AppTheme.accentGreen.withAlpha(26),
                                      AppTheme.highlightYellow.withAlpha(13),
                                    ],
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: weather['color'].withAlpha(51),
                                ),
                                child: Icon(
                                  weather['icon'],
                                  color: weather['color'],
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  weather['name'],
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.primaryBackground,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: AppTheme.accentGreen,
                                  size: 20.sp,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCardWidget(
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentGreen.withAlpha(26),
                ),
                child: Icon(
                  Icons.golf_course,
                  color: AppTheme.accentGreen,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Course Setup',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBackground,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Course Name - Full width mobile input
          _buildMobileTextField(
            controller: _courseNameController,
            label: 'Course Name',
            hintText: 'Enter course name',
            icon: Icons.location_on,
            onChanged: (_) => _updateCourse(),
          ),

          SizedBox(height: 2.h),

          // Course Rating and Slope Rating - Side by side for mobile
          Row(
            children: [
              Expanded(
                child: _buildMobileTextField(
                  controller: _courseRatingController,
                  label: 'Course Rating',
                  hintText: '72.0',
                  icon: Icons.trending_up,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => _updateCourse(),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildMobileTextField(
                  controller: _slopeRatingController,
                  label: 'Slope Rating',
                  hintText: '113',
                  icon: Icons.show_chart,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updateCourse(),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Weather Selector - Mobile optimized
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weather Conditions',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBackground,
                ),
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: _showWeatherSelector,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.accentGreen.withAlpha(77),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withAlpha(26),
                        AppTheme.highlightYellow.withAlpha(13),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _getWeatherColor(_selectedWeather).withAlpha(51),
                        ),
                        child: Icon(
                          _getWeatherIcon(_selectedWeather),
                          color: _getWeatherColor(_selectedWeather),
                          size: 18.sp,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          _selectedWeather,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBackground,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.accentGreen.withAlpha(26),
                        ),
                        child: Icon(
                          Icons.expand_more,
                          color: AppTheme.accentGreen,
                          size: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Tee Time Selector - Mobile optimized
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tee Time',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBackground,
                ),
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: _selectTime,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.accentGreen.withAlpha(77),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withAlpha(26),
                        AppTheme.highlightYellow.withAlpha(13),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.accentGreen.withAlpha(26),
                        ),
                        child: Icon(
                          Icons.access_time,
                          color: AppTheme.accentGreen,
                          size: 18.sp,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          _selectedTime.format(context),
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBackground,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppTheme.highlightYellow.withAlpha(51),
                        ),
                        child: Text(
                          'Tap to change',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBackground.withAlpha(179),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBackground,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.white.withAlpha(26),
                AppTheme.highlightYellow.withAlpha(13),
              ],
            ),
            border: Border.all(
              color: AppTheme.accentGreen.withAlpha(77),
              width: 1.5,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryBackground,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.primaryBackground.withAlpha(128),
              ),
              prefixIcon: Container(
                margin: EdgeInsets.all(3.w),
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentGreen.withAlpha(26),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.accentGreen,
                  size: 16.sp,
                ),
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppTheme.accentGreen,
                  width: 2,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String weather) {
    switch (weather.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'windy':
        return Icons.air;
      case 'rainy':
        return Icons.umbrella;
      default:
        return Icons.wb_sunny;
    }
  }

  Color _getWeatherColor(String weather) {
    switch (weather.toLowerCase()) {
      case 'clear':
        return Colors.orange;
      case 'cloudy':
        return Colors.grey;
      case 'windy':
        return Colors.blue;
      case 'rainy':
        return Colors.blue.shade700;
      default:
        return Colors.orange;
    }
  }
}
