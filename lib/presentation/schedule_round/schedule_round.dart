import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/advanced_options_widget.dart';
import './widgets/cost_calculation_widget.dart';
import './widgets/course_selection_widget.dart';
import './widgets/date_time_picker_widget.dart';
import './widgets/friends_invitation_widget.dart';
import './widgets/notes_section_widget.dart';

class ScheduleRound extends StatefulWidget {
  const ScheduleRound({super.key});

  @override
  State<ScheduleRound> createState() => _ScheduleRoundState();
}

class _ScheduleRoundState extends State<ScheduleRound> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Services
  final FriendInviteService _inviteService = FriendInviteService();
  final NotificationsService _notificationsService = NotificationsService();

  // Form state variables
  Map<String, dynamic>? selectedCourse;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<Map<String, dynamic>> selectedFriends = [];
  String notes = '';
  String selectedFormat = 'Stroke Play';
  bool useHandicap = true;
  bool isPrivate = false;
  double totalCost = 0.0;

  // Mock data for courses
  final List<Map<String, dynamic>> mockCourses = [
    {
      "id": 1,
      "name": "Pebble Beach Golf Links",
      "location": "Pebble Beach, CA",
      "distance": "2.3 miles",
      "rating": 4.8,
      "greenFee": 595.0,
      "image":
          "https://images.unsplash.com/photo-1587174486073-ae5e5cff23aa?fm=jpg&q=60&w=3000",
      "description":
          "World-renowned oceanfront golf course with breathtaking views"
    },
    {
      "id": 2,
      "name": "Augusta National Golf Club",
      "location": "Augusta, GA",
      "distance": "5.7 miles",
      "rating": 4.9,
      "greenFee": 450.0,
      "image":
          "https://images.unsplash.com/photo-1535131749006-b7f58c99034b?fm=jpg&q=60&w=3000",
      "description":
          "Home of the Masters Tournament, pristine conditions year-round"
    },
    {
      "id": 3,
      "name": "St. Andrews Old Course",
      "location": "St. Andrews, Scotland",
      "distance": "12.1 miles",
      "rating": 4.7,
      "greenFee": 320.0,
      "image":
          "https://images.unsplash.com/photo-1593111774240-d529f12cf4bb?fm=jpg&q=60&w=3000",
      "description":
          "The home of golf, historic links course with centuries of tradition"
    }
  ];

  // Mock data for friends
  final List<Map<String, dynamic>> mockFriends = [
    {
      "id": 1,
      "name": "Michael Johnson",
      "username": "@mikegolf",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "handicap": 12,
      "isOnline": true
    },
    {
      "id": 2,
      "name": "Sarah Williams",
      "username": "@sarahswings",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "handicap": 8,
      "isOnline": false
    },
    {
      "id": 3,
      "name": "David Chen",
      "username": "@davepar",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "handicap": 15,
      "isOnline": true
    },
    {
      "id": 4,
      "name": "Emma Rodriguez",
      "username": "@emmagolf",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "handicap": 6,
      "isOnline": true
    }
  ];

  bool get isFormValid {
    return selectedCourse != null &&
        selectedDate != null &&
        selectedTime != null;
  }

  void _calculateTotalCost() {
    if (selectedCourse != null) {
      final greenFee = (selectedCourse!["greenFee"] as double);
      final participantCount =
          selectedFriends.length + 1; // +1 for current user
      setState(() {
        totalCost = greenFee * participantCount;
      });
    }
  }

  void _onCourseSelected(Map<String, dynamic> course) {
    setState(() {
      selectedCourse = course;
    });
    _calculateTotalCost();
  }

  void _onDateTimeSelected(DateTime date, TimeOfDay time) {
    setState(() {
      selectedDate = date;
      selectedTime = time;
    });
  }

  void _onFriendsSelected(List<Map<String, dynamic>> friends) {
    setState(() {
      selectedFriends = friends;
    });
    _calculateTotalCost();
  }

  void _onNotesChanged(String value) {
    setState(() {
      notes = value;
    });
  }

  void _onAdvancedOptionsChanged({
    String? format,
    bool? handicap,
    bool? privacy,
  }) {
    setState(() {
      if (format != null) selectedFormat = format;
      if (handicap != null) useHandicap = handicap;
      if (privacy != null) isPrivate = privacy;
    });
  }

  void _createRound() {
    if (!isFormValid) return;

    final Map<String, dynamic> roundData = {
      'course': selectedCourse,
      'date': selectedDate,
      'time': selectedTime,
      'notes': notes,
    };

    // Send invites and notify friends
    // TODO: Replace with actual service implementation
    _inviteService.sendInvites(selectedFriends, roundData);
    _notificationsService.sendPushNotification('Round created');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Round created successfully! Invitations sent to ${selectedFriends.length} friends.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate back or to round details
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        title: Text(
          'Schedule Round',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: isFormValid ? _createRound : null,
            child: Text(
              'Create',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isFormValid
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.textDisabledLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Selection
              CourseSelectionWidget(
                courses: mockCourses,
                selectedCourse: selectedCourse,
                onCourseSelected: _onCourseSelected,
              ),

              SizedBox(height: 3.h),

              // Date & Time Picker
              DateTimePickerWidget(
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                onDateTimeSelected: _onDateTimeSelected,
              ),

              SizedBox(height: 3.h),

              // Friends Invitation
              FriendsInvitationWidget(
                friends: mockFriends,
                selectedFriends: selectedFriends,
                onFriendsSelected: _onFriendsSelected,
              ),

              SizedBox(height: 3.h),

              // Cost Calculation
              CostCalculationWidget(
                selectedCourse: selectedCourse,
                selectedFriends: selectedFriends,
                totalCost: totalCost,
              ),

              SizedBox(height: 3.h),

              // Notes Section
              NotesSectionWidget(
                notes: notes,
                onNotesChanged: _onNotesChanged,
              ),

              SizedBox(height: 3.h),

              // Advanced Options
              AdvancedOptionsWidget(
                selectedFormat: selectedFormat,
                useHandicap: useHandicap,
                isPrivate: isPrivate,
                onOptionsChanged: _onAdvancedOptionsChanged,
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: isFormValid ? _createRound : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFormValid
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.textDisabledLight,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                elevation: isFormValid ? 3.0 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                'Create Round',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
