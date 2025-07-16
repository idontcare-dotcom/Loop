import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/liquid_glass_theme.dart';

class LiquidGlassNextRoundWidget extends StatelessWidget {
  final Map<String, dynamic> roundData;
  final VoidCallback onTap;
  final VoidCallback onMessageGroup;
  final VoidCallback onGetDirections;
  final VoidCallback onCancelRound;

  const LiquidGlassNextRoundWidget({
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
      child: GlassCardWidget(
        onTap: onTap,
        borderRadius: 28.0,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            LiquidGlassTheme.glassPrimary.withAlpha(38),
            LiquidGlassTheme.glassWhite.withAlpha(13),
            LiquidGlassTheme.glassSecondary.withAlpha(20),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        LiquidGlassTheme.glassPrimary.withAlpha(77),
                        LiquidGlassTheme.glassPrimary.withAlpha(26),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: LiquidGlassTheme.glassPrimary.withAlpha(102),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    'NEXT ROUND',
                    style: LiquidGlassTheme.glassTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: LiquidGlassTheme.glassPrimary,
                    ),
                  ),
                ),
                const Spacer(),
                _buildGlassMenuButton(context),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              roundData["courseName"] as String,
              style: LiquidGlassTheme.glassTextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: LiquidGlassTheme.glassBlack.withAlpha(230),
              ),
            ),
            SizedBox(height: 1.5.h),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        LiquidGlassTheme.glassPrimary.withAlpha(51),
                        LiquidGlassTheme.glassPrimary.withAlpha(13),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: LiquidGlassTheme.glassPrimary.withAlpha(77),
                      width: 1.0,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'schedule',
                    color: LiquidGlassTheme.glassPrimary,
                    size: 18,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${roundData["date"]}',
                        style: LiquidGlassTheme.glassTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: LiquidGlassTheme.glassBlack.withAlpha(204),
                        ),
                      ),
                      Text(
                        '${roundData["time"]}',
                        style: LiquidGlassTheme.glassTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: LiquidGlassTheme.glassBlack.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    LiquidGlassTheme.glassWhite.withAlpha(102),
                    LiquidGlassTheme.glassWhite.withAlpha(26),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: LiquidGlassTheme.glassWhite.withAlpha(153),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Playing with:',
                    style: LiquidGlassTheme.glassTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: LiquidGlassTheme.glassBlack.withAlpha(179),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Row(
                      children: [
                        ...invitedFriends.take(3).map((friend) => Container(
                              margin: EdgeInsets.only(right: 2.w),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      LiquidGlassTheme.glassWhite
                                          .withAlpha(153),
                                      LiquidGlassTheme.glassWhite.withAlpha(51),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: LiquidGlassTheme.glassWhite
                                        .withAlpha(204),
                                    width: 2.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: LiquidGlassTheme.glassBlack
                                          .withAlpha(26),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: CustomImageWidget(
                                    imageUrl: friend["avatar"] as String,
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )),
                        if (invitedFriends.length > 3)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  LiquidGlassTheme.glassPrimary.withAlpha(77),
                                  LiquidGlassTheme.glassPrimary.withAlpha(26),
                                ],
                              ),
                              border: Border.all(
                                color: LiquidGlassTheme.glassPrimary
                                    .withAlpha(128),
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '+${invitedFriends.length - 3}',
                                style: LiquidGlassTheme.glassTextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: LiquidGlassTheme.glassPrimary,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassMenuButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            LiquidGlassTheme.glassWhite.withAlpha(102),
            LiquidGlassTheme.glassWhite.withAlpha(26),
          ],
        ),
        border: Border.all(
          color: LiquidGlassTheme.glassWhite.withAlpha(153),
          width: 1.0,
        ),
      ),
      child: PopupMenuButton<String>(
        icon: CustomIconWidget(
          iconName: 'more_vert',
          color: LiquidGlassTheme.glassBlack.withAlpha(179),
          size: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.transparent,
        elevation: 0,
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
          _buildGlassMenuItem('message', 'Message Group', 'message'),
          _buildGlassMenuItem('directions', 'Get Directions', 'directions'),
          _buildGlassMenuItem('cancel', 'Cancel Round', 'cancel',
              isDestructive: true),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildGlassMenuItem(
    String value,
    String title,
    String iconName, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem(
      value: value,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              LiquidGlassTheme.glassWhite.withAlpha(77),
              LiquidGlassTheme.glassWhite.withAlpha(26),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: LiquidGlassTheme.glassWhite.withAlpha(102),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isDestructive
                  ? Colors.red.withAlpha(204)
                  : LiquidGlassTheme.glassBlack.withAlpha(204),
              size: 18,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: LiquidGlassTheme.glassTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDestructive
                    ? Colors.red.withAlpha(204)
                    : LiquidGlassTheme.glassBlack.withAlpha(204),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
