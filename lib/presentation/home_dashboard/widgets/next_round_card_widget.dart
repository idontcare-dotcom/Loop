import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NextRoundCardWidget extends StatelessWidget {
  final Map<String, dynamic> roundData;
  final VoidCallback onTap;
  final VoidCallback onMessageGroup;
  final VoidCallback onGetDirections;
  final VoidCallback onCancelRound;

  const NextRoundCardWidget({
    super.key,
    required this.roundData,
    required this.onTap,
    required this.onMessageGroup,
    required this.onGetDirections,
    required this.onCancelRound,
  });

  @override
  Widget build(BuildContext context) {
    final invitedFriends =
        (roundData["invitedFriends"] as List).cast<Map<String, dynamic>>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Card(
        elevation: 4,
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'NEXT ROUND',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      icon: CustomIconWidget(
                        iconName: 'more_vert',
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                        size: 20,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'message':
                            onMessageGroup();
                            break;
                          case 'directions':
                            onGetDirections();
                            break;
                          case 'cancel':
                            onCancelRound();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'message',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'message',
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 18,
                              ),
                              SizedBox(width: 2.w),
                              Text('Message Group'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'directions',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'directions',
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 18,
                              ),
                              SizedBox(width: 2.w),
                              Text('Get Directions'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'cancel',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'cancel',
                                color: Theme.of(context).colorScheme.error,
                                size: 18,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Cancel Round',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  roundData["courseName"] as String,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: Theme.of(context).colorScheme.primary,
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${roundData["date"]} at ${roundData["time"]}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      'Playing with:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Row(
                        children: [
                          ...invitedFriends.take(3).map((friend) => Container(
                                margin: EdgeInsets.only(right: 1.w),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  child: ClipOval(
                                    child: CustomImageWidget(
                                      imageUrl: friend["avatar"] as String,
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )),
                          if (invitedFriends.length > 3)
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '+${invitedFriends.length - 3}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
