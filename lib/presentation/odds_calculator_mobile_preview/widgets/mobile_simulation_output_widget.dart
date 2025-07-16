import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../models/player_model.dart';
import '../../../models/simulation_result_model.dart';

class MobileSimulationOutputWidget extends StatefulWidget {
  final List<SimulationResultModel> results;
  final bool isVsMode;
  final VoidCallback onToggleVsMode;
  final List<PlayerModel> selectedPlayers;
  final Function(PlayerModel, PlayerModel)? onHeadToHeadSelected;
  final HeadToHeadResult? headToHeadResult;

  const MobileSimulationOutputWidget({
    super.key,
    required this.results,
    required this.isVsMode,
    required this.onToggleVsMode,
    required this.selectedPlayers,
    this.onHeadToHeadSelected,
    this.headToHeadResult,
  });

  @override
  State<MobileSimulationOutputWidget> createState() =>
      _MobileSimulationOutputWidgetState();
}

class _MobileSimulationOutputWidgetState
    extends State<MobileSimulationOutputWidget> with TickerProviderStateMixin {
  PlayerModel? _selectedPlayer1;
  PlayerModel? _selectedPlayer2;
  late AnimationController _switchController;
  late Animation<double> _switchAnimation;

  @override
  void initState() {
    super.initState();
    _switchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _switchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _switchController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVsMode) {
      _switchController.forward();
    }
  }

  @override
  void dispose() {
    _switchController.dispose();
    super.dispose();
  }

  void _onPlayer1Selected(PlayerModel? player) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedPlayer1 = player;
      if (_selectedPlayer1 != null && _selectedPlayer2 != null) {
        widget.onHeadToHeadSelected?.call(_selectedPlayer1!, _selectedPlayer2!);
      }
    });
  }

  void _onPlayer2Selected(PlayerModel? player) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedPlayer2 = player;
      if (_selectedPlayer1 != null && _selectedPlayer2 != null) {
        widget.onHeadToHeadSelected?.call(_selectedPlayer1!, _selectedPlayer2!);
      }
    });
  }

  void _toggleMode() {
    HapticFeedback.mediumImpact();
    if (widget.isVsMode) {
      _switchController.reverse();
    } else {
      _switchController.forward();
    }
    widget.onToggleVsMode();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCardWidget(
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accentGreen.withAlpha(26),
                    ),
                    child: Icon(
                      Icons.analytics,
                      color: AppTheme.accentGreen,
                      size: 16.sp,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Simulation Results',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBackground,
                    ),
                  ),
                ],
              ),
              _MobileVsModeToggle(
                isVsMode: widget.isVsMode,
                onToggle: _toggleMode,
                animation: _switchAnimation,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (widget.results.isEmpty)
            _MobileEmptyResultsState()
          else if (widget.isVsMode)
            _MobileVsModeView(
              players: widget.selectedPlayers,
              selectedPlayer1: _selectedPlayer1,
              selectedPlayer2: _selectedPlayer2,
              onPlayer1Selected: _onPlayer1Selected,
              onPlayer2Selected: _onPlayer2Selected,
              headToHeadResult: widget.headToHeadResult,
            )
          else
            _MobileLeaderboardView(results: widget.results),
        ],
      ),
    );
  }
}

class _MobileVsModeToggle extends StatelessWidget {
  final bool isVsMode;
  final VoidCallback onToggle;
  final Animation<double> animation;

  const _MobileVsModeToggle({
    required this.isVsMode,
    required this.onToggle,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: isVsMode
                ? [AppTheme.accentGreen, AppTheme.accentGreen.withAlpha(204)]
                : [
                    AppTheme.primaryBackground.withAlpha(51),
                    AppTheme.primaryBackground.withAlpha(26),
                  ],
          ),
          border: Border.all(
            color: isVsMode
                ? AppTheme.accentGreen
                : AppTheme.primaryBackground.withAlpha(77),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: animation.value * 3.14159,
                  child: Icon(
                    Icons.compare_arrows,
                    color: isVsMode
                        ? Colors.white
                        : AppTheme.primaryBackground.withAlpha(179),
                    size: 16.sp,
                  ),
                );
              },
            ),
            SizedBox(width: 2.w),
            Text(
              'Vs. Mode',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isVsMode
                    ? Colors.white
                    : AppTheme.primaryBackground.withAlpha(179),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileEmptyResultsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBackground.withAlpha(13),
            AppTheme.highlightYellow.withAlpha(13),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryBackground.withAlpha(26),
              ),
              child: Icon(
                Icons.analytics_outlined,
                size: 32.sp,
                color: AppTheme.primaryBackground.withAlpha(128),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'No simulation results yet',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBackground.withAlpha(179),
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.highlightYellow.withAlpha(26),
              ),
              child: Text(
                'Add players and course details to see odds',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBackground.withAlpha(128),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileLeaderboardView extends StatelessWidget {
  final List<SimulationResultModel> results;

  const _MobileLeaderboardView({required this.results});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mobile-optimized header
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppTheme.accentGreen.withAlpha(26),
                AppTheme.highlightYellow.withAlpha(13),
              ],
            ),
          ),
          child: Text(
            'Leaderboard - Swipe for details',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBackground,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 2.h),

        // Mobile-optimized results list
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: results.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final result = results[index];
            return _MobilePlayerResultCard(result: result, rank: index + 1);
          },
        ),
      ],
    );
  }
}

class _MobilePlayerResultCard extends StatelessWidget {
  final SimulationResultModel result;
  final int rank;

  const _MobilePlayerResultCard({
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
    final isTopRank = rank <= 3;

    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: rank == 1
                ? [
                    AppTheme.accentGreen.withAlpha(26),
                    AppTheme.highlightYellow.withAlpha(13),
                  ]
                : [
                    Colors.white.withAlpha(26),
                    Colors.white.withAlpha(13),
                  ],
          ),
          border: Border.all(
            color: rank == 1
                ? AppTheme.accentGreen.withAlpha(77)
                : AppTheme.primaryBackground.withAlpha(51),
            width: rank == 1 ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Rank and Avatar
            Column(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isTopRank
                          ? [
                              AppTheme.accentGreen,
                              AppTheme.accentGreen.withAlpha(204)
                            ]
                          : [
                              AppTheme.primaryBackground.withAlpha(51),
                              AppTheme.primaryBackground.withAlpha(26),
                            ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      rank.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: isTopRank
                            ? Colors.white
                            : AppTheme.primaryBackground,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.accentGreen,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: result.player.avatarUrl != null
                        ? CustomImageWidget(
                            imageUrl: result.player.avatarUrl,
                            width: 10.w,
                            height: 10.w,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppTheme.accentGreen.withAlpha(51),
                            child: Center(
                              child: Text(
                                result.player.name
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.accentGreen,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),

            SizedBox(width: 4.w),

            // Player Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.player.name,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBackground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppTheme.primaryBackground.withAlpha(26),
                        ),
                        child: Text(
                          'HCP ${result.player.handicapIndex.toStringAsFixed(1)}',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBackground.withAlpha(179),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppTheme.highlightYellow.withAlpha(26),
                        ),
                        child: Text(
                          result.mostLikelyScoreRange,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Win Probability - Large touch target
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    winColor.withAlpha(26),
                    winColor.withAlpha(51),
                  ],
                ),
                border: Border.all(
                  color: winColor,
                  width: 3,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${result.winProbability.toStringAsFixed(0)}%',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: winColor,
                      ),
                    ),
                    Text(
                      'WIN',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: winColor.withAlpha(204),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileVsModeView extends StatelessWidget {
  final List<PlayerModel> players;
  final PlayerModel? selectedPlayer1;
  final PlayerModel? selectedPlayer2;
  final Function(PlayerModel?) onPlayer1Selected;
  final Function(PlayerModel?) onPlayer2Selected;
  final HeadToHeadResult? headToHeadResult;

  const _MobileVsModeView({
    required this.players,
    required this.selectedPlayer1,
    required this.selectedPlayer2,
    required this.onPlayer1Selected,
    required this.onPlayer2Selected,
    required this.headToHeadResult,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mobile Player Selection
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppTheme.accentGreen.withAlpha(13),
                AppTheme.highlightYellow.withAlpha(13),
              ],
            ),
          ),
          child: Column(
            children: [
              Text(
                'Select Players to Compare',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBackground,
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _MobilePlayerDropdown(
                      label: 'Player 1',
                      players: players,
                      selectedPlayer: selectedPlayer1,
                      onChanged: onPlayer1Selected,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accentGreen.withAlpha(26),
                    ),
                    child: Text(
                      'VS',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accentGreen,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _MobilePlayerDropdown(
                      label: 'Player 2',
                      players: players,
                      selectedPlayer: selectedPlayer2,
                      onChanged: onPlayer2Selected,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (headToHeadResult != null) ...[
          SizedBox(height: 3.h),
          _MobileHeadToHeadResults(result: headToHeadResult!),
        ],
      ],
    );
  }
}

class _MobilePlayerDropdown extends StatelessWidget {
  final String label;
  final List<PlayerModel> players;
  final PlayerModel? selectedPlayer;
  final Function(PlayerModel?) onChanged;

  const _MobilePlayerDropdown({
    required this.label,
    required this.players,
    required this.selectedPlayer,
    required this.onChanged,
  });

  void _showPlayerSelection(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppTheme.primaryBackground.withAlpha(77),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Text(
                    'Select $label',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBackground,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ...players.map((player) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onChanged(player);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.primaryBackground.withAlpha(51),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10.w,
                                height: 10.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.accentGreen,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: player.avatarUrl != null
                                      ? CustomImageWidget(
                                          imageUrl: player.avatarUrl!,
                                          width: 10.w,
                                          height: 10.w,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: AppTheme.accentGreen
                                              .withAlpha(51),
                                          child: Center(
                                            child: Text(
                                              player.name
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: GoogleFonts.inter(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.accentGreen,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      player.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.primaryBackground,
                                      ),
                                    ),
                                    Text(
                                      'HCP ${player.handicapIndex.toStringAsFixed(1)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppTheme.primaryBackground
                                            .withAlpha(179),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBackground,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: () => _showPlayerSelection(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentGreen.withAlpha(77),
                width: 1.5,
              ),
              color: Colors.white.withAlpha(26),
            ),
            child: selectedPlayer != null
                ? Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.accentGreen,
                            width: 1,
                          ),
                        ),
                        child: ClipOval(
                          child: selectedPlayer!.avatarUrl != null
                              ? CustomImageWidget(
                                  imageUrl: selectedPlayer!.avatarUrl!,
                                  width: 8.w,
                                  height: 8.w,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: AppTheme.accentGreen.withAlpha(51),
                                  child: Center(
                                    child: Text(
                                      selectedPlayer!.name
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.accentGreen,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          selectedPlayer!.name,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBackground,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Select ${label.toLowerCase()}',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.primaryBackground.withAlpha(128),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _MobileHeadToHeadResults extends StatelessWidget {
  final HeadToHeadResult result;

  const _MobileHeadToHeadResults({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.accentGreen.withAlpha(26),
            AppTheme.highlightYellow.withAlpha(26),
          ],
        ),
        border: Border.all(
          color: AppTheme.accentGreen.withAlpha(77),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Head-to-Head Analysis',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBackground,
            ),
          ),
          SizedBox(height: 3.h),

          // Mobile-optimized win percentage bar
          Container(
            height: 8.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withAlpha(26),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: result.player1WinPercentage.round(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(16)),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentGreen,
                          AppTheme.accentGreen.withAlpha(204)
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${result.player1WinPercentage.toStringAsFixed(0)}%',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: result.player2WinPercentage.round(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(16)),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.highlightYellow,
                          AppTheme.highlightYellow.withAlpha(204)
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${result.player2WinPercentage.toStringAsFixed(0)}%',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryBackground,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Player names with larger touch targets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppTheme.accentGreen.withAlpha(26),
                ),
                child: Text(
                  result.player1.name,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppTheme.highlightYellow.withAlpha(26),
                ),
                child: Text(
                  result.player2.name,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBackground,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Score differential with mobile-friendly styling
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.highlightYellow.withAlpha(26),
              border: Border.all(
                color: AppTheme.highlightYellow.withAlpha(77),
                width: 1,
              ),
            ),
            child: Text(
              'Avg Score Differential: ${result.averageScoreDifferential.toStringAsFixed(1)} strokes',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
