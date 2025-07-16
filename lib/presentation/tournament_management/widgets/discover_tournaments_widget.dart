import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './tournament_card_widget.dart';

class DiscoverTournamentsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> tournaments;
  final bool isLoading;
  final Function(Map<String, dynamic>) onTournamentTap;
  final Function(Map<String, dynamic>) onJoinTournament;

  const DiscoverTournamentsWidget({
    super.key,
    required this.tournaments,
    required this.isLoading,
    required this.onTournamentTap,
    required this.onJoinTournament,
  });

  @override
  State<DiscoverTournamentsWidget> createState() =>
      _DiscoverTournamentsWidgetState();
}

class _DiscoverTournamentsWidgetState extends State<DiscoverTournamentsWidget> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Stroke Play',
    'Match Play',
    'Scramble',
    'Team Play'
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final filteredTournaments = _selectedFilter == 'All'
        ? widget.tournaments
        : widget.tournaments
            .where((t) => t['format'] == _selectedFilter)
            .toList();

    return Column(
      children: [
        _buildFilterChips(),
        SizedBox(height: 1.h),
        Expanded(
          child: filteredTournaments.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: EdgeInsets.all(4.w),
                  itemCount: filteredTournaments.length,
                  itemBuilder: (context, index) {
                    final tournament = filteredTournaments[index];
                    return TournamentCardWidget(
                      tournament: tournament,
                      onTap: () => widget.onTournamentTap(tournament),
                      onSecondaryAction: () =>
                          _showJoinConfirmation(context, tournament),
                      actionLabel: 'Join',
                      showParticipantCount: true,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(
                filter,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              selectedColor: Theme.of(context).colorScheme.primary,
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No tournaments found',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _selectedFilter == 'All'
                ? 'Try refreshing or check back later for new tournaments'
                : 'No tournaments found for "$_selectedFilter" format',
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

  void _showJoinConfirmation(
      BuildContext context, Map<String, dynamic> tournament) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Join Tournament',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Join "${tournament["name"]}"?',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Entry Fee: \$${tournament["entryFee"].toStringAsFixed(0)}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Format: ${tournament["format"]}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Course: ${tournament["course"]}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
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
              widget.onJoinTournament(tournament);
            },
            child: Text(
              'Join Tournament',
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
