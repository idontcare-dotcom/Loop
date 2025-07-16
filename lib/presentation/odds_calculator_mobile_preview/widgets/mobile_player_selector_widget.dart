import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../models/player_model.dart';

class MobilePlayerSelectorWidget extends StatefulWidget {
  final List<PlayerModel> selectedPlayers;
  final Function(List<PlayerModel>) onPlayersChanged;
  final int maxPlayers;

  const MobilePlayerSelectorWidget({
    super.key,
    required this.selectedPlayers,
    required this.onPlayersChanged,
    this.maxPlayers = 20,
  });

  @override
  State<MobilePlayerSelectorWidget> createState() =>
      _MobilePlayerSelectorWidgetState();
}

class _MobilePlayerSelectorWidgetState
    extends State<MobilePlayerSelectorWidget> {
  final ScrollController _scrollController = ScrollController();

  // Mock player data optimized for mobile preview
  final List<PlayerModel> _availablePlayers = [
    PlayerModel(
        id: '1',
        name: 'Alice Johnson',
        handicapIndex: 10.2,
        recentScores: [84, 88, 82, 86, 85],
        avatarUrl:
            'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?w=150&h=150&fit=crop&crop=face'),
    PlayerModel(
        id: '2',
        name: 'Bob Wilson',
        handicapIndex: 13.1,
        recentScores: [89, 91, 87, 88, 90],
        avatarUrl:
            'https://images.pixabay.com/photo/2016/11/21/12/42/beard-1845166_1280.jpg?w=150&h=150&fit=crop&crop=face'),
    PlayerModel(
        id: '3',
        name: 'Sam Rodriguez',
        handicapIndex: 8.7,
        recentScores: [80, 84, 82, 85, 81],
        avatarUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face'),
    PlayerModel(
        id: '4',
        name: 'Emma Chen',
        handicapIndex: 15.4,
        recentScores: [92, 89, 94, 88, 91],
        avatarUrl:
            'https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?w=150&h=150&fit=crop&crop=face'),
    PlayerModel(
        id: '5',
        name: 'Mike Thompson',
        handicapIndex: 6.3,
        recentScores: [78, 82, 79, 81, 77],
        avatarUrl:
            'https://images.pixabay.com/photo/2014/04/02/10/25/man-303792_1280.png?w=150&h=150&fit=crop&crop=face'),
    PlayerModel(
        id: '6',
        name: 'Sarah Lee',
        handicapIndex: 12.8,
        recentScores: [86, 90, 85, 88, 87],
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face'),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showMobilePlayerSelection() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MobilePlayerSelectionModal(
        availablePlayers: _availablePlayers,
        selectedPlayers: widget.selectedPlayers,
        maxPlayers: widget.maxPlayers,
        onSelectionChanged: widget.onPlayersChanged,
      ),
    );
  }

  void _removePlayer(PlayerModel player) {
    HapticFeedback.lightImpact();
    final updatedPlayers = List<PlayerModel>.from(widget.selectedPlayers);
    updatedPlayers.remove(player);
    widget.onPlayersChanged(updatedPlayers);
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
                      Icons.people,
                      color: AppTheme.accentGreen,
                      size: 16.sp,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Players',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBackground,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppTheme.accentGreen.withAlpha(26),
                  border: Border.all(
                    color: AppTheme.accentGreen.withAlpha(77),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${widget.selectedPlayers.length}/${widget.maxPlayers}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (widget.selectedPlayers.isEmpty)
            _MobileEmptyPlayerState(onTap: _showMobilePlayerSelection)
          else
            _MobileSelectedPlayersRow(
              players: widget.selectedPlayers,
              onRemove: _removePlayer,
              onAddMore: _showMobilePlayerSelection,
              canAddMore: widget.selectedPlayers.length < widget.maxPlayers,
              scrollController: _scrollController,
            ),
        ],
      ),
    );
  }
}

class _MobileEmptyPlayerState extends StatelessWidget {
  final VoidCallback onTap;

  const _MobileEmptyPlayerState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: 15.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.accentGreen.withAlpha(13),
              AppTheme.highlightYellow.withAlpha(13),
            ],
          ),
          border: Border.all(
            color: AppTheme.accentGreen.withAlpha(77),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentGreen.withAlpha(26),
                ),
                child: Icon(
                  Icons.person_add,
                  size: 24.sp,
                  color: AppTheme.accentGreen,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Tap to Select Players',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentGreen,
                ),
              ),
              Text(
                'Touch-optimized selection',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.primaryBackground.withAlpha(128),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileSelectedPlayersRow extends StatelessWidget {
  final List<PlayerModel> players;
  final Function(PlayerModel) onRemove;
  final VoidCallback onAddMore;
  final bool canAddMore;
  final ScrollController scrollController;

  const _MobileSelectedPlayersRow({
    required this.players,
    required this.onRemove,
    required this.onAddMore,
    required this.canAddMore,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Players - Swipe to browse',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryBackground.withAlpha(179),
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: players.length + (canAddMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == players.length && canAddMore) {
                return Padding(
                  padding: EdgeInsets.only(right: 3.w),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onAddMore();
                    },
                    child: Container(
                      width: 25.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.accentGreen.withAlpha(128),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        color: AppTheme.accentGreen.withAlpha(13),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: AppTheme.accentGreen,
                            size: 24.sp,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Add More',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.accentGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final player = players[index];
              return Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: _MobilePlayerChip(
                  player: player,
                  onRemove: () => onRemove(player),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MobilePlayerChip extends StatelessWidget {
  final PlayerModel player;
  final VoidCallback onRemove;

  const _MobilePlayerChip({
    required this.player,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentGreen,
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.accentGreen.withAlpha(26),
            AppTheme.highlightYellow.withAlpha(13),
          ],
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
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
                            width: 8.w,
                            height: 8.w,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppTheme.accentGreen.withAlpha(51),
                            child: Center(
                              child: Text(
                                player.name.substring(0, 1).toUpperCase(),
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
                SizedBox(height: 1.h),
                Text(
                  player.name.split(' ').first,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBackground,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.highlightYellow.withAlpha(51),
                  ),
                  child: Text(
                    player.handicapIndex.toStringAsFixed(1),
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 1.w,
            right: 1.w,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onRemove();
              },
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.close,
                  size: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobilePlayerSelectionModal extends StatefulWidget {
  final List<PlayerModel> availablePlayers;
  final List<PlayerModel> selectedPlayers;
  final int maxPlayers;
  final Function(List<PlayerModel>) onSelectionChanged;

  const _MobilePlayerSelectionModal({
    required this.availablePlayers,
    required this.selectedPlayers,
    required this.maxPlayers,
    required this.onSelectionChanged,
  });

  @override
  State<_MobilePlayerSelectionModal> createState() =>
      _MobilePlayerSelectionModalState();
}

class _MobilePlayerSelectionModalState
    extends State<_MobilePlayerSelectionModal> {
  late List<PlayerModel> _tempSelectedPlayers;

  @override
  void initState() {
    super.initState();
    _tempSelectedPlayers = List<PlayerModel>.from(widget.selectedPlayers);
  }

  void _togglePlayer(PlayerModel player) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_tempSelectedPlayers.contains(player)) {
        _tempSelectedPlayers.remove(player);
      } else if (_tempSelectedPlayers.length < widget.maxPlayers) {
        _tempSelectedPlayers.add(player);
      }
    });
  }

  void _confirmSelection() {
    HapticFeedback.mediumImpact();
    widget.onSelectionChanged(_tempSelectedPlayers);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 20,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Players',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBackground,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppTheme.accentGreen.withAlpha(26),
                        border: Border.all(
                          color: AppTheme.accentGreen.withAlpha(77),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${_tempSelectedPlayers.length}/${widget.maxPlayers}',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: widget.availablePlayers.length,
              itemBuilder: (context, index) {
                final player = widget.availablePlayers[index];
                final isSelected = _tempSelectedPlayers.contains(player);
                final canSelect =
                    _tempSelectedPlayers.length < widget.maxPlayers;

                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accentGreen
                          : AppTheme.primaryBackground.withAlpha(51),
                      width: isSelected ? 2 : 1,
                    ),
                    color: isSelected
                        ? AppTheme.accentGreen.withAlpha(13)
                        : Colors.transparent,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(3.w),
                    leading: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.accentGreen
                              : AppTheme.primaryBackground.withAlpha(77),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: player.avatarUrl != null
                            ? CustomImageWidget(
                                imageUrl: player.avatarUrl!,
                                width: 12.w,
                                height: 12.w,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: AppTheme.accentGreen.withAlpha(51),
                                child: Center(
                                  child: Text(
                                    player.name.substring(0, 1).toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.accentGreen,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    title: Text(
                      player.name,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBackground,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Handicap: ${player.handicapIndex.toStringAsFixed(1)}',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBackground.withAlpha(179),
                          ),
                        ),
                        Text(
                          'Avg Score: ${player.averageScore.toStringAsFixed(1)}',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.primaryBackground.withAlpha(128),
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppTheme.accentGreen
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.accentGreen
                              : AppTheme.primaryBackground.withAlpha(128),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16.sp,
                            )
                          : null,
                    ),
                    onTap: (canSelect || isSelected)
                        ? () => _togglePlayer(player)
                        : null,
                  ),
                );
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _confirmSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Confirm Selection (${_tempSelectedPlayers.length})',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
