import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/score_celebration_widget.dart';

class ScoreEntryWidget extends StatefulWidget {
  final int par;
  final int currentScore;
  final Function(int) onScoreChanged;

  const ScoreEntryWidget({
    super.key,
    required this.par,
    required this.currentScore,
    required this.onScoreChanged,
  });

  @override
  State<ScoreEntryWidget> createState() => _ScoreEntryWidgetState();
}

class _ScoreEntryWidgetState extends State<ScoreEntryWidget> {
  OverlayEntry? _celebrationOverlay;

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
    if (diff == -4) return AppTheme.birdieColors['condor']!;
    if (diff == -3) return AppTheme.birdieColors['albatross']!;
    if (diff == -2) return AppTheme.birdieColors['eagle']!;
    if (diff == -1) return AppTheme.birdieColors['birdie']!;
    if (diff == 0) return AppTheme.lightTheme.colorScheme.primary;
    if (diff == 1) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  bool _isBirdieOrBetter(int score, int par) {
    return score < par;
  }

  void _showCelebration(int score, int par) {
    final scoreLabel = _getScoreLabel(score, par);

    if (_isBirdieOrBetter(score, par)) {
      _celebrationOverlay = _createCelebrationOverlay(scoreLabel, score, par);
      Overlay.of(context).insert(_celebrationOverlay!);
    }
  }

  OverlayEntry _createCelebrationOverlay(String scoreType, int score, int par) {
    return OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: ScoreCelebrationWidget(
            scoreType: scoreType,
            score: score,
            par: par,
            onAnimationComplete: () {
              _celebrationOverlay?.remove();
              _celebrationOverlay = null;
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _celebrationOverlay?.remove();
    super.dispose();
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
          if (widget.currentScore > 0) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: _getScoreColor(widget.currentScore, widget.par)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: _getScoreColor(widget.currentScore, widget.par),
                  width: 2.0,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '${widget.currentScore}',
                    style: AppTheme.dataTextStyle(
                      isLight: true,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ).copyWith(
                      color: _getScoreColor(widget.currentScore, widget.par),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _getScoreLabel(widget.currentScore, widget.par),
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: _getScoreColor(widget.currentScore, widget.par),
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
              itemCount: widget.par >= 5
                  ? 9
                  : 8, // Show more options for par 5 to include albatross
              itemBuilder: (context, index) {
                final score = widget.par >= 5
                    ? widget.par - 3 + index
                    : widget.par - 2 + index;
                final isSelected = widget.currentScore == score;
                final scoreColor = _getScoreColor(score, widget.par);

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    widget.onScoreChanged(score);
                    _showCelebration(score, widget.par);
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
                          _getScoreLabel(score, widget.par),
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
