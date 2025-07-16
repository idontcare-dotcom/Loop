import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './tournament_card_widget.dart';

class JoinedTournamentsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tournaments;
  final bool isLoading;
  final Function(Map<String, dynamic>) onTournamentTap;
  final Function(Map<String, dynamic>) onLeaveTournament;

  const JoinedTournamentsWidget({
    super.key,
    required this.tournaments,
    required this.isLoading,
    required this.onTournamentTap,
    required this.onLeaveTournament,
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
          actionLabel: 'View',
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
            iconName: 'sports_golf',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No tournaments joined yet',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Discover and join tournaments to compete with other golfers',
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
                iconName: 'visibility',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'View Details',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onTournamentTap(tournament);
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
                iconName: 'message',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                'Tournament Chat',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to tournament chat
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'exit_to_app',
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Leave Tournament',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showLeaveConfirmation(context, tournament);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showLeaveConfirmation(
      BuildContext context, Map<String, dynamic> tournament) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Leave Tournament',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to leave "${tournament["name"]}"? This action cannot be undone.',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onLeaveTournament(tournament);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(
              'Leave',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
