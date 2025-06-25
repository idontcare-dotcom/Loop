import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlayerRowWidget extends StatelessWidget {
  final Map<String, dynamic> player;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PlayerRowWidget({
    super.key,
    required this.player,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scoreToPar = player['scoreToPar'] as int? ?? 0;
    final isLive = player['isLive'] as bool? ?? false;
    final holesCompleted = player['holesCompleted'] as int? ?? 0;
    final totalHoles = 18;

    Color scoreColor = Theme.of(context).textTheme.bodyMedium!.color!;
    String scoreText = scoreToPar == 0 ? 'E' : scoreToPar.toString();

    if (scoreToPar < 0) {
      scoreColor = AppTheme.successLight;
    } else if (scoreToPar > 0) {
      scoreColor = AppTheme.errorLight;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              // Position
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _getPositionColor(context, player['position'] as int),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${player['position']}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),

              // Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: player['avatar'] as String,
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),

              // Player info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            player['name'] as String,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isLive) ...[
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 2.w,
                                  height: 2.w,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'LIVE',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Text(
                          'Holes: $holesCompleted/$totalHoles',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (player['lastUpdated'] != null) ...[
                          SizedBox(width: 2.w),
                          Text(
                            '• ${player['lastUpdated']}',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color!
                                          .withOpacity(0.7),
                                    ),
                          ),
                        ],
                      ],
                    ),
                    if (holesCompleted < totalHoles) ...[
                      SizedBox(height: 1.h),
                      LinearProgressIndicator(
                        value: holesCompleted / totalHoles,
                        backgroundColor: Theme.of(context)
                            .primaryColor
                            .withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Score
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    scoreText,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: scoreColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (player['totalStrokes'] != null) ...[
                    Text(
                      '${player['totalStrokes']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (player['trend'] != null) ...[
                    SizedBox(height: 0.5.h),
                    CustomIconWidget(
                      iconName: _getTrendIcon(player['trend'] as String),
                      color: _getTrendColor(context, player['trend'] as String),
                      size: 16,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPositionColor(BuildContext context, int position) {
    switch (position) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Theme.of(context).primaryColor;
    }
  }

  String _getTrendIcon(String trend) {
    switch (trend) {
      case 'up':
        return 'trending_up';
      case 'down':
        return 'trending_down';
      case 'stable':
        return 'trending_flat';
      default:
        return 'trending_flat';
    }
  }

  Color _getTrendColor(BuildContext context, String trend) {
    switch (trend) {
      case 'up':
        return AppTheme.successLight;
      case 'down':
        return AppTheme.errorLight;
      case 'stable':
        return Theme.of(context).textTheme.bodyMedium!.color!;
      default:
        return Theme.of(context).textTheme.bodyMedium!.color!;
    }
  }
}
