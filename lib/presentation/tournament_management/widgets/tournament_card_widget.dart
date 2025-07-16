import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TournamentCardWidget extends StatelessWidget {
  final Map<String, dynamic> tournament;
  final VoidCallback onTap;
  final VoidCallback? onSecondaryAction;
  final String actionLabel;
  final bool showParticipantCount;

  const TournamentCardWidget({
    super.key,
    required this.tournament,
    required this.onTap,
    this.onSecondaryAction,
    required this.actionLabel,
    this.showParticipantCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 3.h),
        child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tournament Image
                      ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: CustomImageWidget(
                              imageUrl: tournament["imageUrl"] ?? "",
                              height: 20.h,
                              width: double.infinity,
                              fit: BoxFit.cover)),

                      Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tournament Name and Status
                                Row(children: [
                                  Expanded(
                                      child: Text(
                                          tournament["name"] ?? "Tournament",
                                          style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis)),
                                  _buildStatusChip(context),
                                ]),

                                SizedBox(height: 1.h),

                                // Course and Format
                                Row(children: [
                                  CustomIconWidget(
                                      iconName: 'location_on',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      size: 16),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                      child: Text(
                                          tournament["course"] ??
                                              "Unknown Course",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis)),
                                ]),

                                SizedBox(height: 0.5.h),

                                Row(children: [
                                  CustomIconWidget(
                                      iconName: 'sports_golf',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      size: 16),
                                  SizedBox(width: 1.w),
                                  Text(tournament["format"] ?? "Unknown Format",
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant)),
                                ]),

                                SizedBox(height: 1.h),

                                // Date and Entry Fee
                                Row(children: [
                                  CustomIconWidget(
                                      iconName: 'event',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      size: 16),
                                  SizedBox(width: 1.w),
                                  Text(_formatDate(tournament["startDate"]),
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant)),
                                  const Spacer(),
                                  Text(
                                      '\$${(tournament["entryFee"])?.toStringAsFixed(0) ?? "0"}',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                ]),

                                if (showParticipantCount) ...[
                                  SizedBox(height: 1.h),

                                  // Participants
                                  Row(children: [
                                    CustomIconWidget(
                                        iconName: 'people',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        size: 16),
                                    SizedBox(width: 1.w),
                                    Text(
                                        '${tournament["participants"] ?? 0}/${tournament["maxParticipants"] ?? 0} players',
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant)),
                                  ]),

                                  SizedBox(height: 1.h),

                                  // Progress Bar
                                  LinearProgressIndicator(
                                      value: (tournament["participants"] ?? 0) /
                                          (tournament["maxParticipants"] ?? 1),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      borderRadius: BorderRadius.circular(4)),
                                ],

                                if (onSecondaryAction != null) ...[
                                  SizedBox(height: 2.h),

                                  // Action Button
                                  SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          onPressed: onSecondaryAction,
                                          child: Text(actionLabel,
                                              style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w500)))),
                                ],
                              ])),
                    ]))));
  }

  Widget _buildStatusChip(BuildContext context) {
    final status = tournament["status"] ?? "Unknown";
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'open':
        backgroundColor = Theme.of(context).colorScheme.primaryContainer;
        textColor = Theme.of(context).colorScheme.onPrimaryContainer;
        break;
      case 'full':
        backgroundColor = Theme.of(context).colorScheme.errorContainer;
        textColor = Theme.of(context).colorScheme.onErrorContainer;
        break;
      case 'live':
        backgroundColor = Theme.of(context).colorScheme.tertiaryContainer;
        textColor = Theme.of(context).colorScheme.onTertiaryContainer;
        break;
      case 'completed':
        backgroundColor = Theme.of(context).colorScheme.surfaceContainer;
        textColor = Theme.of(context).colorScheme.onSurfaceVariant;
        break;
      default:
        backgroundColor = Theme.of(context).colorScheme.surfaceContainer;
        textColor = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        child: Text(status,
            style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w500, color: textColor)));
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return "TBD";

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = date.difference(now).inDays;

      if (difference == 0) {
        return "Today";
      } else if (difference == 1) {
        return "Tomorrow";
      } else if (difference < 7) {
        return "$difference days away";
      } else {
        final months = [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec"
        ];
        return "${months[date.month - 1]} ${date.day}";
      }
    } catch (e) {
      return dateString;
    }
  }
}
