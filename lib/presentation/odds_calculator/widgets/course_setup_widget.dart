import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../models/course_model.dart';

class CourseSetupWidget extends StatefulWidget {
  final CourseModel? course;
  final Function(CourseModel) onCourseChanged;

  const CourseSetupWidget({
    super.key,
    this.course,
    required this.onCourseChanged,
  });

  @override
  State<CourseSetupWidget> createState() => _CourseSetupWidgetState();
}

class _CourseSetupWidgetState extends State<CourseSetupWidget> {
  final _courseNameController = TextEditingController();
  final _courseRatingController = TextEditingController();
  final _slopeRatingController = TextEditingController();

  String _selectedWeather = 'Clear';
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<String> _weatherOptions = [
    'Clear',
    'Cloudy',
    'Windy',
    'Rainy',
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

  @override
  Widget build(BuildContext context) {
    return GlassCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course Setup',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBackground,
            ),
          ),
          SizedBox(height: 2.h),

          // Course Name
          _buildTextField(
            controller: _courseNameController,
            label: 'Course Name',
            hintText: 'Enter course name',
            onChanged: (_) => _updateCourse(),
          ),

          SizedBox(height: 2.h),

          // Course Rating and Slope Rating Row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _courseRatingController,
                  label: 'Course Rating',
                  hintText: '72.0',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => _updateCourse(),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildTextField(
                  controller: _slopeRatingController,
                  label: 'Slope Rating',
                  hintText: '113',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updateCourse(),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Weather Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weather',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBackground,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.accentGreen.withAlpha(77),
                    width: 1.5,
                  ),
                  color: Colors.white.withAlpha(13),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedWeather,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.accentGreen,
                    ),
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.primaryBackground,
                    ),
                    items: _weatherOptions.map((String weather) {
                      return DropdownMenuItem<String>(
                        value: weather,
                        child: Row(
                          children: [
                            _getWeatherIcon(weather),
                            SizedBox(width: 2.w),
                            Text(weather),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedWeather = newValue;
                        });
                        _updateCourse();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Tee Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tee Time',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBackground,
                ),
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: _selectTime,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.accentGreen.withAlpha(77),
                      width: 1.5,
                    ),
                    color: Colors.white.withAlpha(13),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTime.format(context),
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.primaryBackground,
                        ),
                      ),
                      Icon(
                        Icons.access_time,
                        color: AppTheme.accentGreen,
                        size: 20.sp,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
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
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryBackground,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.primaryBackground,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.primaryBackground.withAlpha(128),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppTheme.accentGreen.withAlpha(77),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppTheme.accentGreen.withAlpha(77),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppTheme.accentGreen,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white.withAlpha(13),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          ),
        ),
      ],
    );
  }

  Widget _getWeatherIcon(String weather) {
    IconData iconData;
    Color iconColor;

    switch (weather.toLowerCase()) {
      case 'clear':
        iconData = Icons.wb_sunny;
        iconColor = Colors.orange;
        break;
      case 'cloudy':
        iconData = Icons.cloud;
        iconColor = Colors.grey;
        break;
      case 'windy':
        iconData = Icons.air;
        iconColor = Colors.blue;
        break;
      case 'rainy':
        iconData = Icons.umbrella;
        iconColor = Colors.blue.shade700;
        break;
      default:
        iconData = Icons.wb_sunny;
        iconColor = Colors.orange;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 18.sp,
    );
  }
}
