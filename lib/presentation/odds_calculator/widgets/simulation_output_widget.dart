import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../models/player_model.dart';
import '../../../models/simulation_result_model.dart';

class SimulationOutputWidget extends StatefulWidget {
  final List<SimulationResultModel> results;
  final bool isVsMode;
  final VoidCallback onToggleVsMode;
  final List<PlayerModel> selectedPlayers;
  final Function(PlayerModel, PlayerModel)? onHeadToHeadSelected;
  final HeadToHeadResult? headToHeadResult;

  const SimulationOutputWidget({
    super.key,
    required this.results,
    required this.isVsMode,
    required this.onToggleVsMode,
    required this.selectedPlayers,
    this.onHeadToHeadSelected,
    this.headToHeadResult,
  });

  @override
  State<SimulationOutputWidget> createState() => _SimulationOutputWidgetState();
}

class _SimulationOutputWidgetState extends State<SimulationOutputWidget> {
  PlayerModel? _selectedPlayer1;
  PlayerModel? _selectedPlayer2;

  void _onPlayer1Selected(PlayerModel? player) {
    setState(() {
      _selectedPlayer1 = player;
      if (_selectedPlayer1 != null && _selectedPlayer2 != null) {
        widget.onHeadToHeadSelected?.call(_selectedPlayer1!, _selectedPlayer2!);
      }
    });
  }

  void _onPlayer2Selected(PlayerModel? player) {
    setState(() {
      _selectedPlayer2 = player;
      if (_selectedPlayer1 != null && _selectedPlayer2 != null) {
        widget.onHeadToHeadSelected?.call(_selectedPlayer1!, _selectedPlayer2!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlassCardWidget(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Simulation Results',
            style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBackground)),
        Row(children: [
          Text('Vs. Mode',
              style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBackground)),
          SizedBox(width: 2.w),
          Switch(
              value: widget.isVsMode,
              onChanged: (_) => widget.onToggleVsMode(),
              activeColor: AppTheme.accentGreen,
              activeTrackColor: AppTheme.accentGreen.withAlpha(77)),
        ]),
      ]),
      SizedBox(height: 2.h),
      if (widget.results.isEmpty)
        _EmptyResultsState()
      else if (widget.isVsMode)
        _VsModeView(
            players: widget.selectedPlayers,
            selectedPlayer1: _selectedPlayer1,
            selectedPlayer2: _selectedPlayer2,
            onPlayer1Selected: _onPlayer1Selected,
            onPlayer2Selected: _onPlayer2Selected,
            headToHeadResult: widget.headToHeadResult)
      else
        _LeaderboardView(results: widget.results),
    ]));
  }
}

class _EmptyResultsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 20.h,
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.analytics_outlined,
              size: 32.sp, color: AppTheme.primaryBackground.withAlpha(128)),
          SizedBox(height: 1.h),
          Text('No simulation results yet',
              style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBackground.withAlpha(179))),
          SizedBox(height: 0.5.h),
          Text('Add players and course details to see odds',
              style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.primaryBackground.withAlpha(128)),
              textAlign: TextAlign.center),
        ])));
  }
}

class _LeaderboardView extends StatelessWidget {
  final List<SimulationResultModel> results;

  const _LeaderboardView({required this.results});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Header Row
      Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.accentGreen.withAlpha(26)),
          child: Row(children: [
            SizedBox(width: 12.w),
            Expanded(
                flex: 3,
                child: Text('Player',
                    style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBackground))),
            Expanded(
                flex: 2,
                child: Text('Handicap',
                    style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBackground),
                    textAlign: TextAlign.center)),
            Expanded(
                flex: 2,
                child: Text('Score',
                    style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBackground),
                    textAlign: TextAlign.center)),
            Expanded(
                flex: 2,
                child: Text('Win %',
                    style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBackground),
                    textAlign: TextAlign.center)),
          ])),
      SizedBox(height: 1.h),

      // Results List
      ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: results.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final result = results[index];
            return _PlayerResultRow(result: result, rank: index + 1);
          }),
    ]);
  }
}

class _PlayerResultRow extends StatelessWidget {
  final SimulationResultModel result;
  final int rank;

  const _PlayerResultRow({
    required this.result,
    required this.rank,
  });

  Color _getWinProbabilityColor(double winPercentage) {
    if (winPercentage >= 40) {
      return AppTheme.accentGreen;
    } else if (winPercentage >= 20) {
      return AppTheme.highlightYellow;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final winColor = _getWinProbabilityColor(result.winProbability);

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: rank == 1
                ? AppTheme.accentGreen.withAlpha(13)
                : Colors.transparent,
            border: rank == 1
                ? Border.all(
                    color: AppTheme.accentGreen.withAlpha(77), width: 1)
                : null),
        child: Row(children: [
          // Rank Badge
          Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: rank == 1
                      ? AppTheme.accentGreen
                      : AppTheme.primaryBackground.withAlpha(26)),
              child: Center(
                  child: Text(rank.toString(),
                      style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: rank == 1
                              ? Colors.white
                              : AppTheme.primaryBackground)))),
          SizedBox(width: 2.w),

          // Player Info
          Expanded(
              flex: 3,
              child: Row(children: [
                CircleAvatar(
                    backgroundColor: AppTheme.accentGreen.withAlpha(51),
                    child: result.player.avatarUrl != null
                        ? CustomImageWidget(
                            imageUrl: result.player.avatarUrl,
                            width: 4.h,
                            height: 4.h,
                            fit: BoxFit.cover)
                        : Text(result.player.name.substring(0, 1).toUpperCase(),
                            style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.accentGreen))),
                SizedBox(width: 2.w),
                Expanded(
                    child: Text(result.player.name,
                        style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBackground),
                        overflow: TextOverflow.ellipsis)),
              ])),

          // Handicap
          Expanded(
              flex: 2,
              child: Text(result.player.handicapIndex.toStringAsFixed(1),
                  style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.primaryBackground.withAlpha(204)),
                  textAlign: TextAlign.center)),

          // Most Likely Score
          Expanded(
              flex: 2,
              child: Column(children: [
                Text(result.mostLikelyScoreRange,
                    style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBackground),
                    textAlign: TextAlign.center),
              ])),

          // Win Probability
          Expanded(
              flex: 2,
              child: Column(children: [
                Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: winColor.withAlpha(26),
                        border: Border.all(color: winColor, width: 2)),
                    child: Center(
                        child: Text(
                            '${result.winProbability.toStringAsFixed(0)}%',
                            style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: winColor)))),
              ])),
        ]));
  }
}

class _VsModeView extends StatelessWidget {
  final List<PlayerModel> players;
  final PlayerModel? selectedPlayer1;
  final PlayerModel? selectedPlayer2;
  final Function(PlayerModel?) onPlayer1Selected;
  final Function(PlayerModel?) onPlayer2Selected;
  final HeadToHeadResult? headToHeadResult;

  const _VsModeView({
    required this.players,
    required this.selectedPlayer1,
    required this.selectedPlayer2,
    required this.onPlayer1Selected,
    required this.onPlayer2Selected,
    required this.headToHeadResult,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Player Selection
      Row(children: [
        Expanded(
            child: _PlayerDropdown(
                label: 'Player 1',
                players: players,
                selectedPlayer: selectedPlayer1,
                onChanged: onPlayer1Selected)),
        SizedBox(width: 4.w),
        Text('VS',
            style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.accentGreen)),
        SizedBox(width: 4.w),
        Expanded(
            child: _PlayerDropdown(
                label: 'Player 2',
                players: players,
                selectedPlayer: selectedPlayer2,
                onChanged: onPlayer2Selected)),
      ]),

      if (headToHeadResult != null) ...[
        SizedBox(height: 3.h),
        _HeadToHeadResults(result: headToHeadResult!),
      ],
    ]);
  }
}

class _PlayerDropdown extends StatelessWidget {
  final String label;
  final List<PlayerModel> players;
  final PlayerModel? selectedPlayer;
  final Function(PlayerModel?) onChanged;

  const _PlayerDropdown({
    required this.label,
    required this.players,
    required this.selectedPlayer,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryBackground)),
      SizedBox(height: 1.h),
      Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppTheme.accentGreen.withAlpha(77), width: 1.5),
              color: Colors.white.withAlpha(13)),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<PlayerModel>(
                  value: selectedPlayer,
                  hint: Text('Select ${label.toLowerCase()}',
                      style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.primaryBackground.withAlpha(128))),
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: AppTheme.accentGreen),
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  items: players.map((PlayerModel player) {
                    return DropdownMenuItem<PlayerModel>(
                        value: player,
                        child: Text(player.name,
                            style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.primaryBackground)));
                  }).toList(),
                  onChanged: onChanged))),
    ]);
  }
}

class _HeadToHeadResults extends StatelessWidget {
  final HeadToHeadResult result;

  const _HeadToHeadResults({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.accentGreen.withAlpha(26),
                  AppTheme.highlightYellow.withAlpha(13),
                ]),
            border: Border.all(
                color: AppTheme.accentGreen.withAlpha(77), width: 1)),
        child: Column(children: [
          Text('Head-to-Head Analysis',
              style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBackground)),
          SizedBox(height: 2.h),

          // Win Percentages Bar Chart
          Container(
              height: 6.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withAlpha(26)),
              child: Row(children: [
                Expanded(
                    flex: result.player1WinPercentage.round(),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(12)),
                            color: AppTheme.accentGreen),
                        child: Center(
                            child: Text(
                                '${result.player1WinPercentage.toStringAsFixed(0)}%',
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white))))),
                Expanded(
                    flex: result.player2WinPercentage.round(),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(12)),
                            color: AppTheme.highlightYellow),
                        child: Center(
                            child: Text(
                                '${result.player2WinPercentage.toStringAsFixed(0)}%',
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryBackground))))),
              ])),

          SizedBox(height: 2.h),

          // Player Names
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(result.player1.name,
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.accentGreen)),
            Text(result.player2.name,
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryBackground)),
          ]),

          SizedBox(height: 1.h),

          // Average Score Differential
          Text(
              'Avg Score Differential: ${result.averageScoreDifferential.toStringAsFixed(1)} strokes',
              style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.primaryBackground.withAlpha(204))),
        ]));
  }
}
