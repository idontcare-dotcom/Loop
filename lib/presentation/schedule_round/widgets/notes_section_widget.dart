import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotesSectionWidget extends StatefulWidget {
  final String notes;
  final Function(String) onNotesChanged;

  const NotesSectionWidget({
    super.key,
    required this.notes,
    required this.onNotesChanged,
  });

  @override
  State<NotesSectionWidget> createState() => _NotesSectionWidgetState();
}

class _NotesSectionWidgetState extends State<NotesSectionWidget> {
  final TextEditingController _notesController = TextEditingController();
  final int maxCharacters = 500;

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.notes;
    _notesController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    widget.onNotesChanged(_notesController.text);
  }

  int get remainingCharacters => maxCharacters - _notesController.text.length;

  Color get characterCountColor {
    if (remainingCharacters < 50) {
      return AppTheme.errorLight;
    } else if (remainingCharacters < 100) {
      return AppTheme.warningLight;
    }
    return AppTheme.textMediumEmphasisLight;
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
                  iconName: 'note',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Notes & Details',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),

            SizedBox(height: 2.h),

            Text(
              'Add any additional details about the round (optional)',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
            ),

            SizedBox(height: 2.h),

            // Notes text field
            TextField(
              controller: _notesController,
              maxLines: 4,
              maxLength: maxCharacters,
              decoration: InputDecoration(
                hintText:
                    'e.g., Bring your A-game! Planning to play the back nine first. Meet at the clubhouse 30 minutes early for warm-up...',
                hintMaxLines: 3,
                counterText: '', // Hide default counter
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.dividerLight,
                    style: BorderStyle.solid,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.dividerLight,
                    style: BorderStyle.solid,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                contentPadding: EdgeInsets.all(4.w),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textCapitalization: TextCapitalization.sentences,
            ),

            SizedBox(height: 1.h),

            // Character counter and suggestions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Tip: Include meeting time, special instructions, or course preferences',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '$remainingCharacters left',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: characterCountColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            if (_notesController.text.isNotEmpty) ...[
              SizedBox(height: 2.h),

              // Preview container
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
                          iconName: 'preview',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Preview',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _notesController.text,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 2.h),

            // Quick suggestions
            Text(
              'Quick Add',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: [
                _buildSuggestionChip('Meet 30 min early'),
                _buildSuggestionChip('Bring extra balls'),
                _buildSuggestionChip('Casual dress code'),
                _buildSuggestionChip('19th hole after'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String suggestion) {
    return InkWell(
      onTap: () {
        final currentText = _notesController.text;
        final newText =
            currentText.isEmpty ? suggestion : '$currentText. $suggestion';

        if (newText.length <= maxCharacters) {
          _notesController.text = newText;
          _notesController.selection = TextSelection.fromPosition(
            TextPosition(offset: newText.length),
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.dividerLight,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'add',
              color: AppTheme.textMediumEmphasisLight,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Text(
              suggestion,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.removeListener(_onTextChanged);
    _notesController.dispose();
    super.dispose();
  }
}
