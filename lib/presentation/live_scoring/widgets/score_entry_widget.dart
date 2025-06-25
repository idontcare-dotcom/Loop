import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ScoreEntryWidget extends StatelessWidget {
  final int par;
  final int currentScore;
  final Function(int) onScoreChanged;

  const ScoreEntryWidget({
    super.key,
    required this.par,
    required this.currentScore,
    required this.onScoreChanged,
  });

  String _getScoreLabel(int score, int par) {
    final diff = score - par;
    if (diff == 0) return 'PAR';
    if (diff == -4) return 'CONDOR';
    if (diff == -3) return 'ALBATROSS';
    if (diff == -2) return 'EAGLE';
    if (diff == -1) return 'BIRDIE';
    if (diff == 1) return 'BOGEY';
    if (diff == 2) return 'DOUBLE';
    if (diff == 3) return 'TRIPLE';
    if (diff > 3) return '+$diff';
    return diff < 0 ? '$diff' : '+$diff';
  }

  Color _getScoreColor(int score, int par) {
    final diff = score - par;
    if (diff < 0) return AppTheme.successLight;
    if (diff == 0) return AppTheme.lightTheme.colorScheme.primary;
    if (diff == 1) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Text(
            'Enter Score',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          if (currentScore > 0) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: _getScoreColor(currentScore, par).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: _getScoreColor(currentScore, par),
                  width: 2.0,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '$currentScore',
                    style: AppTheme.dataTextStyle(
                      isLight: true,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ).copyWith(
                      color: _getScoreColor(currentScore, par),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _getScoreLabel(currentScore, par),
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: _getScoreColor(currentScore, par),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
          ],
          SizedBox(
            height: 12.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 8,
              itemBuilder: (context, index) {
                final score = par - 2 + index;
                final isSelected = currentScore == score;
                final scoreColor = _getScoreColor(score, par);

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onScoreChanged(score);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? scoreColor
                          : AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: isSelected
                            ? scoreColor
                            : AppTheme.lightTheme.dividerColor,
                        width: isSelected ? 3.0 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: scoreColor.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: AppTheme.lightTheme.colorScheme.shadow,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$score',
                          style: AppTheme.dataTextStyle(
                            isLight: true,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ).copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : scoreColor,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          _getScoreLabel(score, par),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                    .withValues(alpha: 0.8)
                                : scoreColor.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
