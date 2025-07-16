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
    try {
      final invitedFriends = (roundData["invitedFriends"] as List?)
              ?.cast<Map<String, dynamic>>() ??
          [];
      final courseName = roundData["courseName"] as String? ?? "Unknown Course";
      final date = roundData["date"] as String? ?? "Unknown Date";
      final time = roundData["time"] as String? ?? "Unknown Time";

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'NEXT ROUND',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
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
                              .withValues(alpha: 0.6),
                          size: 20,
                        ),
                        onSelected: (value) {
                          try {
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
                          } catch (e) {
                            debugPrint('Menu action error: $e');
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'message',
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'message',
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  size: 18,
                                ),
                                SizedBox(width: 2.w),
                                Flexible(child: Text('Message Group')),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'directions',
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'directions',
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  size: 18,
                                ),
                                SizedBox(width: 2.w),
                                Flexible(child: Text('Get Directions')),
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
                                Flexible(
                                  child: Text(
                                    'Cancel Round',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
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
                  SizedBox(height: 2.h),
                  Flexible(
                    child: Text(
                      courseName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
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
                      Flexible(
                        child: Text(
                          '$date at $time',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                          overflow: TextOverflow.ellipsis,
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
                                  .withValues(alpha: 0.6),
                            ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...invitedFriends.take(3).map((friend) {
                                final avatarUrl =
                                    friend["avatar"] as String? ?? "";
                                return Container(
                                  margin: EdgeInsets.only(right: 1.w),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.1),
                                    child: ClipOval(
                                      child: avatarUrl.isNotEmpty
                                          ? CustomImageWidget(
                                              imageUrl: avatarUrl,
                                              width: 32,
                                              height: 32,
                                              fit: BoxFit.cover,
                                            )
                                          : CustomIconWidget(
                                              iconName: 'person',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 20,
                                            ),
                                    ),
                                  ),
                                );
                              }),
                              if (invitedFriends.length > 3)
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.1),
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error building next round card: $e');
      return _buildErrorCard(context);
    }
  }

  Widget _buildErrorCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Card(
        elevation: 4,
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'error',
                color: Theme.of(context).colorScheme.error,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'Error Loading Round',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
