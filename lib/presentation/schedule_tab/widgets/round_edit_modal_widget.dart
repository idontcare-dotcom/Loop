import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoundEditModalWidget extends StatefulWidget {
  final Map<String, dynamic> roundData;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const RoundEditModalWidget({
    super.key,
    required this.roundData,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<RoundEditModalWidget> createState() => _RoundEditModalWidgetState();
}

class _RoundEditModalWidgetState extends State<RoundEditModalWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _courseController;
  late TextEditingController _notesController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  List<Map<String, dynamic>> _selectedPlayers = [];
  String _selectedFormat = 'Stroke Play';

  final List<String> _gameFormats = [
    'Stroke Play',
    'Match Play',
    'Stableford',
    'Best Ball',
    'Scramble',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut)));

    _initializeFields();
    _animationController.forward();
  }

  void _initializeFields() {
    _courseController =
        TextEditingController(text: widget.roundData['courseName'] ?? '');
    _notesController =
        TextEditingController(text: widget.roundData['notes'] ?? '');
    _selectedDate = DateTime.parse(
        widget.roundData['date'] ?? DateTime.now().toIso8601String());
    _selectedTime = TimeOfDay.fromDateTime(_selectedDate);
    _selectedPlayers =
        List<Map<String, dynamic>>.from(widget.roundData['players'] ?? []);
    _selectedFormat = widget.roundData['format'] ?? 'Stroke Play';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _courseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Theme.of(context).colorScheme.primary)),
              child: child!);
        });
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day,
            _selectedTime.hour, _selectedTime.minute);
      });
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
                      primary: Theme.of(context).colorScheme.primary)),
              child: child!);
        });
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
            _selectedDate.day, picked.hour, picked.minute);
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();

      final updatedRound = {
        ...widget.roundData,
        'courseName': _courseController.text,
        'date': _selectedDate.toIso8601String(),
        'time':
            '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
        'format': _selectedFormat,
        'players': _selectedPlayers,
        'notes': _notesController.text,
      };

      widget.onSave(updatedRound);
    }
  }

  Widget _buildPlayerManagement() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Playing Partners',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        GestureDetector(
            onTap: () {
              // Add player functionality
              _showAddPlayerDialog();
            },
            child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: CustomIconWidget(
                    iconName: 'person_add',
                    color: Theme.of(context).colorScheme.primary,
                    size: 20))),
      ]),
      SizedBox(height: 2.h),
      if (_selectedPlayers.isEmpty)
        Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3))),
            child: Row(children: [
              CustomIconWidget(
                  iconName: 'person_add',
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                  size: 24),
              SizedBox(width: 3.w),
              Text('Add players to your round',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7))),
            ]))
      else
        ..._selectedPlayers.map((player) {
          return Container(
              margin: EdgeInsets.only(bottom: 1.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3))),
              child: Row(children: [
                ClipOval(
                    child: CustomImageWidget(
                        imageUrl: player['avatar'] ?? '',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover)),
                SizedBox(width: 3.w),
                Expanded(
                    child: Text(player['name'] ?? 'Unknown Player',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w500))),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPlayers.remove(player);
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .error
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6)),
                        child: CustomIconWidget(
                            iconName: 'close',
                            color: Theme.of(context).colorScheme.error,
                            size: 16))),
              ]));
        }),
    ]);
  }

  void _showAddPlayerDialog() {
    // This would typically show a player selection dialog
    // For now, we'll add a mock player
    setState(() {
      _selectedPlayers.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': 'New Player',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                      .animate(_slideAnimation),
              child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Scaffold(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      appBar: AppBar(
                          title: Text('Edit Round',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                          leading: IconButton(
                              icon: CustomIconWidget(
                                  iconName: 'close',
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  size: 24),
                              onPressed: widget.onCancel),
                          actions: [
                            TextButton(
                                onPressed: _saveChanges,
                                child: Text('Save',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w600))),
                          ]),
                      body: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                              padding: EdgeInsets.all(4.w),
                              child:
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                // Course Selection
                                Text('Golf Course',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600)),
                                SizedBox(height: 1.h),
                                TextFormField(
                                    controller: _courseController,
                                    decoration: const InputDecoration(
                                        hintText: 'Enter course name',
                                        prefixIcon: Icon(Icons.golf_course)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a course name';
                                      }
                                      return null;
                                    }),

                                SizedBox(height: 3.h),

                                // Date and Time
                                Text('Date & Time',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600)),
                                SizedBox(height: 1.h),
                                Row(children: [
                                  Expanded(
                                      child: GestureDetector(
                                          onTap: _selectDate,
                                          child: Container(
                                              padding: EdgeInsets.all(4.w),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline
                                                          .withValues(
                                                              alpha: 0.3))),
                                              child: Row(children: [
                                                CustomIconWidget(
                                                    iconName: 'calendar_today',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    size: 20),
                                                SizedBox(width: 3.w),
                                                Text(
                                                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge),
                                              ])))),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                      child: GestureDetector(
                                          onTap: _selectTime,
                                          child: Container(
                                              padding: EdgeInsets.all(4.w),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline
                                                          .withValues(
                                                              alpha: 0.3))),
                                              child: Row(children: [
                                                CustomIconWidget(
                                                    iconName: 'schedule',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    size: 20),
                                                SizedBox(width: 3.w),
                                                Text(
                                                    '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge),
                                              ])))),
                                ]),

                                SizedBox(height: 3.h),

                                // Game Format
                                Text('Game Format',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600)),
                                SizedBox(height: 1.h),
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline
                                                .withValues(alpha: 0.3))),
                                    child: DropdownButton<String>(
                                        value: _selectedFormat,
                                        isExpanded: true,
                                        underline: Container(),
                                        items:
                                            _gameFormats.map((String format) {
                                          return DropdownMenuItem<String>(
                                              value: format,
                                              child: Text(format));
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              _selectedFormat = newValue;
                                            });
                                          }
                                        })),

                                SizedBox(height: 3.h),

                                // Player Management
                                _buildPlayerManagement(),

                                SizedBox(height: 3.h),

                                // Notes
                                Text('Notes',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600)),
                                SizedBox(height: 1.h),
                                TextFormField(
                                    controller: _notesController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                        hintText:
                                            'Add any notes for this round...',
                                        prefixIcon: Icon(Icons.note))),

                                SizedBox(height: 4.h),

                                // Action Buttons
                                Row(children: [
                                  Expanded(
                                      child: OutlinedButton(
                                          onPressed: widget.onCancel,
                                          child: Text('Cancel',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600)))),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                          onPressed: _saveChanges,
                                          child: Text('Save Changes',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                      fontWeight:
                                                          FontWeight.w600)))),
                                ]),

                                SizedBox(height: 2.h),
                              ]))))));
        });
  }
}
