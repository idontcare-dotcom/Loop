import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MiniScorecardWidget extends StatelessWidget {
  final int currentHole;
  final Map<int, int> scores;
  final List<Map<String, dynamic>> holeData;
  final Function(int) onHoleTap;
  final Function(int) onHoleLongPress;

  const MiniScorecardWidget({
    super.key,
    required this.currentHole,
    required this.scores,
    required this.holeData,
    required this.onHoleTap,
    required this.onHoleLongPress,
  });

  Color _getScoreColor(int? score, int par) {
    if (score == null) return AppTheme.lightTheme.colorScheme.outline;
    final diff = score - par;
    if (diff < 0) return AppTheme.successLight;
    if (diff == 0) return AppTheme.lightTheme.colorScheme.primary;
    if (diff == 1) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  int _getTotalScore() {
    return scores.values.fold(0, (sum, score) => sum + score);
  }

  int _getTotalPar() {
    return holeData.fold(0, (sum, hole) => sum + (hole["par"] as int));
  }

  @override
  Widget build(BuildContext context) {
    final totalScore = _getTotalScore();
    final totalPar = _getTotalPar();
    final scoreToPar = totalScore > 0 ? totalScore - totalPar : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Scorecard',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            if (scores.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getScoreColor(totalScore, totalPar)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: _getScoreColor(totalScore, totalPar),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  scoreToPar == 0
                      ? 'E'
                      : scoreToPar > 0
                          ? '+$scoreToPar'
                          : '$scoreToPar',
                  style: AppTheme.dataTextStyle(
                    isLight: true,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ).copyWith(
                    color: _getScoreColor(totalScore, totalPar),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 18,
            itemBuilder: (context, index) {
              final hole = index + 1;
              final holeInfo = holeData[index];
              final par = holeInfo["par"] as int;
              final score = scores[hole];
              final isCurrentHole = hole == currentHole;
              final scoreColor = _getScoreColor(score, par);

              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onHoleTap(hole);
                },
                onLongPress: () {
                  HapticFeedback.mediumImpact();
                  onHoleLongPress(hole);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  width: 16.w,
                  decoration: BoxDecoration(
                    color: isCurrentHole
                        ? AppTheme.lightTheme.colorScheme.primary
                        : score != null
                            ? scoreColor.withOpacity(0.1)
                            : AppTheme.lightTheme.cardColor,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: isCurrentHole
                          ? AppTheme.lightTheme.colorScheme.primary
                          : score != null
                              ? scoreColor
                              : AppTheme.lightTheme.dividerColor,
                      width: isCurrentHole ? 3.0 : 1.0,
                    ),
                    boxShadow: isCurrentHole
                        ? [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$hole',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: isCurrentHole
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Container(
                        width: 8.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: isCurrentHole
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                                  .withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            score?.toString() ?? '-',
                            style: AppTheme.dataTextStyle(
                              isLight: true,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ).copyWith(
                              color: isCurrentHole
                                  ? AppTheme.lightTheme.colorScheme.onPrimary
                                  : score != null
                                      ? scoreColor
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Par $par',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: isCurrentHole
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                                  .withOpacity(0.8)
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
