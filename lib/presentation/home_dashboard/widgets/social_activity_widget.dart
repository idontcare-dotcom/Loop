import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final Function(int) onLike;
  final Function(int) onComment;

  const SocialActivityWidget({
    super.key,
    required this.activities,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Social Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        SizedBox(height: 1.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return _buildActivityCard(context, activity);
          },
        ),
      ],
    );
  }

  Widget _buildActivityCard(
      BuildContext context, Map<String, dynamic> activity) {
    final activityType = activity["type"] as String;
    IconData typeIcon;
    Color typeColor;

    switch (activityType) {
      case 'score':
        typeIcon = Icons.sports_golf;
        typeColor = Theme.of(context).colorScheme.primary;
        break;
      case 'achievement':
        typeIcon = Icons.emoji_events;
        typeColor = Theme.of(context).colorScheme.tertiary;
        break;
      case 'tournament':
        typeIcon = Icons.leaderboard;
        typeColor = Theme.of(context).colorScheme.secondary;
        break;
      default:
        typeIcon = Icons.sports_golf;
        typeColor = Theme.of(context).colorScheme.primary;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        elevation: 1,
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: activity["userAvatar"] as String,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              activity["userName"] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.all(0.5.w),
                              decoration: BoxDecoration(
                                color: typeColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: typeIcon.toString().split('.').last,
                                color: typeColor,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          activity["timestamp"] as String,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                activity["content"] as String,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                    ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  InkWell(
                    onTap: () => onLike(activity["id"] as int),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: activity["isLiked"] as bool
                                ? 'favorite'
                                : 'favorite_border',
                            color: activity["isLiked"] as bool
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6),
                            size: 18,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${activity["likes"]}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  InkWell(
                    onTap: () => onComment(activity["id"] as int),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'chat_bubble_outline',
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                            size: 18,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${activity["comments"]}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
