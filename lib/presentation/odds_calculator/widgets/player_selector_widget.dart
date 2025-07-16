import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../models/player_model.dart';

class PlayerSelectorWidget extends StatefulWidget {
  final List<PlayerModel> selectedPlayers;
  final Function(List<PlayerModel>) onPlayersChanged;
  final int maxPlayers;

  const PlayerSelectorWidget({
    super.key,
    required this.selectedPlayers,
    required this.onPlayersChanged,
    this.maxPlayers = 20,
  });

  @override
  State<PlayerSelectorWidget> createState() => _PlayerSelectorWidgetState();
}

class _PlayerSelectorWidgetState extends State<PlayerSelectorWidget> {
  // Mock player data - in real app this would come from a service
  final List<PlayerModel> _availablePlayers = [
    PlayerModel(
        id: '1',
        name: 'Alice Johnson',
        handicapIndex: 10.2,
        recentScores: [84, 88, 82, 86, 85],
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face'),
    PlayerModel(
        id: '2',
        name: 'Bob Wilson',
        handicapIndex: 13.1,
        recentScores: [89, 91, 87, 88, 90],
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face'),
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
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face'),
    PlayerModel(
        id: '5',
        name: 'Mike Thompson',
        handicapIndex: 6.3,
        recentScores: [78, 82, 79, 81, 77],
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face'),
  ];

  void _showPlayerSelection() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _PlayerSelectionModal(
            availablePlayers: _availablePlayers,
            selectedPlayers: widget.selectedPlayers,
            maxPlayers: widget.maxPlayers,
            onSelectionChanged: widget.onPlayersChanged));
  }

  void _removePlayer(PlayerModel player) {
    final updatedPlayers = List<PlayerModel>.from(widget.selectedPlayers);
    updatedPlayers.remove(player);
    widget.onPlayersChanged(updatedPlayers);
  }

  @override
  Widget build(BuildContext context) {
    return GlassCardWidget(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Players',
            style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBackground)),
        Text('${widget.selectedPlayers.length}/${widget.maxPlayers}',
            style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.accentGreen)),
      ]),
      SizedBox(height: 2.h),
      if (widget.selectedPlayers.isEmpty)
        _EmptyPlayerState(onTap: _showPlayerSelection)
      else
        _SelectedPlayersGrid(
            players: widget.selectedPlayers,
            onRemove: _removePlayer,
            onAddMore: _showPlayerSelection,
            canAddMore: widget.selectedPlayers.length < widget.maxPlayers),
    ]));
  }
}

class _EmptyPlayerState extends StatelessWidget {
  final VoidCallback onTap;

  const _EmptyPlayerState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 12.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.accentGreen.withAlpha(77),
                    width: 2,
                    style: BorderStyle.solid)),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.person_add_outlined,
                      size: 24.sp, color: AppTheme.accentGreen),
                  SizedBox(height: 1.h),
                  Text('Select Players',
                      style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.accentGreen)),
                ]))));
  }
}

class _SelectedPlayersGrid extends StatelessWidget {
  final List<PlayerModel> players;
  final Function(PlayerModel) onRemove;
  final VoidCallback onAddMore;
  final bool canAddMore;

  const _SelectedPlayersGrid({
    required this.players,
    required this.onRemove,
    required this.onAddMore,
    required this.canAddMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Wrap(spacing: 2.w, runSpacing: 1.h, children: [
        ...players.map((player) =>
            _PlayerChip(player: player, onRemove: () => onRemove(player))),
        if (canAddMore)
          GestureDetector(
              onTap: onAddMore,
              child: Container(
                  width: 20.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.accentGreen.withAlpha(128),
                          width: 1.5)),
                  child: Icon(Icons.add,
                      color: AppTheme.accentGreen, size: 20.sp))),
      ]),
    ]);
  }
}

class _PlayerChip extends StatelessWidget {
  final PlayerModel player;
  final VoidCallback onRemove;

  const _PlayerChip({
    required this.player,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 20.w,
        height: 8.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.accentGreen, width: 1.5),
            color: AppTheme.accentGreen.withAlpha(26)),
        child: Stack(children: [
          Padding(
              padding: EdgeInsets.all(1.w),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        backgroundColor: AppTheme.accentGreen.withAlpha(51),
                        child: player.avatarUrl != null
                            ? CustomImageWidget(
                                imageUrl: player.avatarUrl!,
                                width: 4.h,
                                height: 4.h,
                                fit: BoxFit.cover)
                            : Text(player.name.substring(0, 1).toUpperCase(),
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.accentGreen))),
                    SizedBox(height: 0.5.h),
                    Text(player.name.split(' ').first,
                        style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBackground),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(player.handicapIndex.toStringAsFixed(1),
                        style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.primaryBackground.withAlpha(179))),
                  ])),
          Positioned(
              top: 0.5.w,
              right: 0.5.w,
              child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                      width: 5.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: Icon(Icons.close,
                          size: 12.sp, color: Colors.white)))),
        ]));
  }
}

class _PlayerSelectionModal extends StatefulWidget {
  final List<PlayerModel> availablePlayers;
  final List<PlayerModel> selectedPlayers;
  final int maxPlayers;
  final Function(List<PlayerModel>) onSelectionChanged;

  const _PlayerSelectionModal({
    required this.availablePlayers,
    required this.selectedPlayers,
    required this.maxPlayers,
    required this.onSelectionChanged,
  });

  @override
  State<_PlayerSelectionModal> createState() => _PlayerSelectionModalState();
}

class _PlayerSelectionModalState extends State<_PlayerSelectionModal> {
  late List<PlayerModel> _tempSelectedPlayers;

  @override
  void initState() {
    super.initState();
    _tempSelectedPlayers = List<PlayerModel>.from(widget.selectedPlayers);
  }

  void _togglePlayer(PlayerModel player) {
    setState(() {
      if (_tempSelectedPlayers.contains(player)) {
        _tempSelectedPlayers.remove(player);
      } else if (_tempSelectedPlayers.length < widget.maxPlayers) {
        _tempSelectedPlayers.add(player);
      }
    });
  }

  void _confirmSelection() {
    widget.onSelectionChanged(_tempSelectedPlayers);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80.h,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: EdgeInsets.all(4.w),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Select Players',
                style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBackground)),
            Text('${_tempSelectedPlayers.length}/${widget.maxPlayers}',
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.accentGreen)),
          ]),
          SizedBox(height: 2.h),
          Expanded(
              child: ListView.builder(
                  itemCount: widget.availablePlayers.length,
                  itemBuilder: (context, index) {
                    final player = widget.availablePlayers[index];
                    final isSelected = _tempSelectedPlayers.contains(player);
                    final canSelect =
                        _tempSelectedPlayers.length < widget.maxPlayers;

                    return Container(
                        margin: EdgeInsets.only(bottom: 1.h),
                        child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor:
                                    AppTheme.accentGreen.withAlpha(51),
                                child: player.avatarUrl != null
                                    ? CustomImageWidget(
                                        imageUrl: player.avatarUrl!,
                                        width: 6.h,
                                        height: 6.h,
                                        fit: BoxFit.cover)
                                    : Text(player.name.substring(0, 1).toUpperCase(),
                                        style: GoogleFonts.inter(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.accentGreen))),
                            title: Text(player.name,
                                style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.primaryBackground)),
                            subtitle: Text('Handicap: ${player.handicapIndex.toStringAsFixed(1)} | Avg: ${player.averageScore.toStringAsFixed(1)}',
                                style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.primaryBackground
                                        .withAlpha(179))),
                            trailing: Checkbox(
                                value: isSelected,
                                onChanged: (canSelect || isSelected) ? (_) => _togglePlayer(player) : null,
                                activeColor: AppTheme.accentGreen),
                            onTap: (canSelect || isSelected) ? () => _togglePlayer(player) : null));
                  })),
          SizedBox(height: 2.h),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: _confirmSelection,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGreen,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: Text('Confirm Selection',
                      style: GoogleFonts.inter(
                          fontSize: 16.sp, fontWeight: FontWeight.w600)))),
        ]));
  }
}
