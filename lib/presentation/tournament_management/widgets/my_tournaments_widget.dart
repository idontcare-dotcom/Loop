import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './tournament_card_widget.dart';

class MyTournamentsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tournaments;
  final bool isLoading;
  final Function(Map<String, dynamic>) onTournamentTap;
  final Function(Map<String, dynamic>) onEditTournament;
  final Function(Map<String, dynamic>) onCancelTournament;

  const MyTournamentsWidget({
    super.key,
    required this.tournaments,
    required this.isLoading,
    required this.onTournamentTap,
    required this.onEditTournament,
    required this.onCancelTournament,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (tournaments.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: tournaments.length,
      itemBuilder: (context, index) {
        final tournament = tournaments[index];
        return TournamentCardWidget(
          tournament: tournament,
          onTap: () => onTournamentTap(tournament),
          onSecondaryAction: () => _showTournamentOptions(context, tournament),
          actionLabel: 'Manage',
          showParticipantCount: true,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'emoji_events',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No tournaments created yet',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Create your first tournament to get started',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showTournamentOptions(
      BuildContext context, Map<String, dynamic> tournament) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: Theme.of(context).bottomSheetTheme.shape,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'Edit Tournament',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onEditTournament(tournament);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'people',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'Manage Participants',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to participant management
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'leaderboard',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'View Leaderboard',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to tournament leaderboard
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'cancel',
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Cancel Tournament',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              onTap: () {
                Navigator.pop(context);
                onCancelTournament(tournament);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
