import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LeaderboardSheetWidget extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData;
  final VoidCallback onClose;

  const LeaderboardSheetWidget({
    super.key,
    required this.leaderboardData,
    required this.onClose,
  });

  String _getScoreDisplay(int score) {
    if (score == 0) return 'E';
    return score > 0 ? '+$score' : '$score';
  }

  Color _getScoreColor(int score) {
    if (score < 0) return AppTheme.successLight;
    if (score == 0) return AppTheme.lightTheme.colorScheme.primary;
    return AppTheme.errorLight;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 12.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.dividerColor,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Live Leaderboard',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onClose();
                          },
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: leaderboardData.length,
                  itemBuilder: (context, index) {
                    final player = leaderboardData[index];
                    final isCurrentPlayer = player["isCurrentPlayer"] as bool;

                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: isCurrentPlayer
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withOpacity(0.1)
                            : AppTheme.lightTheme.cardColor,
                        borderRadius: BorderRadius.circular(16.0),
                        border: isCurrentPlayer
                            ? Border.all(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                width: 2.0,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? AppTheme.successLight
                                  : AppTheme.lightTheme.colorScheme.outline,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: AppTheme.dataTextStyle(
                                  isLight: true,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ).copyWith(
                                  color: index == 0
                                      ? AppTheme
                                          .lightTheme.colorScheme.onPrimary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: CustomImageWidget(
                              imageUrl: player["avatar"] as String,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player["name"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: isCurrentPlayer
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'Thru ${player["thru"]}',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color:
                                  _getScoreColor(player["currentScore"] as int)
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: _getScoreColor(
                                    player["currentScore"] as int),
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              _getScoreDisplay(player["currentScore"] as int),
                              style: AppTheme.dataTextStyle(
                                isLight: true,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ).copyWith(
                                color: _getScoreColor(
                                    player["currentScore"] as int),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
