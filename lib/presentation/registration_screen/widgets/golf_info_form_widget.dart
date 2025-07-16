import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class GolfInfoFormWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onGolfInfoChanged;
  final Map<String, dynamic> initialData;

  const GolfInfoFormWidget({
    super.key,
    required this.onGolfInfoChanged,
    this.initialData = const {},
  });

  @override
  State<GolfInfoFormWidget> createState() => _GolfInfoFormWidgetState();
}

class _GolfInfoFormWidgetState extends State<GolfInfoFormWidget> {
  final _handicapController = TextEditingController();
  final _homeCourseController = TextEditingController();
  String _playingFrequency = 'weekly';
  bool _isHandicapOfficial = false;

  final List<String> _frequencyOptions = [
    'daily',
    'weekly',
    'biweekly',
    'monthly',
    'occasionally'
  ];

  final Map<String, String> _frequencyLabels = {
    'daily': 'Daily',
    'weekly': 'Weekly',
    'biweekly': 'Bi-weekly',
    'monthly': 'Monthly',
    'occasionally': 'Occasionally'
  };

  @override
  void initState() {
    super.initState();
    _handicapController.text = widget.initialData['handicap']?.toString() ?? '';
    _homeCourseController.text = widget.initialData['homeCourse'] ?? '';
    _playingFrequency = widget.initialData['playingFrequency'] ?? 'weekly';
    _isHandicapOfficial = widget.initialData['isHandicapOfficial'] ?? false;

    _handicapController.addListener(_notifyChanges);
    _homeCourseController.addListener(_notifyChanges);
  }

  void _notifyChanges() {
    widget.onGolfInfoChanged({
      'handicap': _handicapController.text.isEmpty
          ? null
          : double.tryParse(_handicapController.text),
      'homeCourse': _homeCourseController.text,
      'playingFrequency': _playingFrequency,
      'isHandicapOfficial': _isHandicapOfficial,
    });
  }

  String? _validateHandicap(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Handicap is optional
    }
    final handicap = double.tryParse(value);
    if (handicap == null) {
      return 'Please enter a valid number';
    }
    if (handicap < -10 || handicap > 54) {
      return 'Handicap must be between -10 and 54';
    }
    return null;
  }

  @override
  void dispose() {
    _handicapController.dispose();
    _homeCourseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Golf Information',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Help us personalize your experience (optional)',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 3.h),
        _buildHandicapField(),
        SizedBox(height: 3.h),
        _buildHomeCourseField(),
        SizedBox(height: 3.h),
        _buildPlayingFrequencySection(),
      ],
    );
  }

  Widget _buildHandicapField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _handicapController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          validator: _validateHandicap,
          decoration: InputDecoration(
            labelText: 'Handicap (Optional)',
            hintText: 'Enter your current handicap',
            prefixIcon: Icon(
              Icons.golf_course,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            helperText: 'Range: -10 to 54',
          ),
        ),
        SizedBox(height: 2.h),
        CheckboxListTile(
          title: Text(
            'Official GHIN Handicap',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'Import from GHIN for verification',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          value: _isHandicapOfficial,
          onChanged: (value) {
            setState(() {
              _isHandicapOfficial = value ?? false;
              _notifyChanges();
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildHomeCourseField() {
    return TextFormField(
      controller: _homeCourseController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Home Course (Optional)',
        hintText: 'Search for your home course',
        prefixIcon: Icon(
          Icons.location_on_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        suffixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: () {
        // Future: Implement course search functionality
        // For now, just show a mock dialog
        _showCourseSearchDialog();
      },
    );
  }

  Widget _buildPlayingFrequencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How often do you play?',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _frequencyOptions.map((frequency) {
            final isSelected = _playingFrequency == frequency;
            return ChoiceChip(
              label: Text(
                _frequencyLabels[frequency]!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _playingFrequency = frequency;
                    _notifyChanges();
                  });
                }
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showCourseSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Course Search',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'GPS-powered course search coming soon!\nFor now, you can type your course name manually.',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
