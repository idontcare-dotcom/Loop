import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FriendsInvitationWidget extends StatefulWidget {
  final List<Map<String, dynamic>> friends;
  final List<Map<String, dynamic>> selectedFriends;
  final Function(List<Map<String, dynamic>>) onFriendsSelected;

  const FriendsInvitationWidget({
    super.key,
    required this.friends,
    required this.selectedFriends,
    required this.onFriendsSelected,
  });

  @override
  State<FriendsInvitationWidget> createState() =>
      _FriendsInvitationWidgetState();
}

class _FriendsInvitationWidgetState extends State<FriendsInvitationWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredFriends = [];

  @override
  void initState() {
    super.initState();
    filteredFriends = widget.friends;
  }

  void _filterFriends(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredFriends = widget.friends;
      } else {
        filteredFriends = widget.friends.where((friend) {
          final name = (friend["name"] as String).toLowerCase();
          final username = (friend["username"] as String).toLowerCase();
          return name.contains(query.toLowerCase()) ||
              username.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _toggleFriendSelection(Map<String, dynamic> friend) {
    final List<Map<String, dynamic>> updatedSelection =
        List.from(widget.selectedFriends);

    final existingIndex = updatedSelection
        .indexWhere((selected) => selected["id"] == friend["id"]);

    if (existingIndex >= 0) {
      updatedSelection.removeAt(existingIndex);
    } else {
      updatedSelection.add(friend);
    }

    widget.onFriendsSelected(updatedSelection);
  }

  bool _isFriendSelected(Map<String, dynamic> friend) {
    return widget.selectedFriends
        .any((selected) => selected["id"] == friend["id"]);
  }

  void _removeFriend(Map<String, dynamic> friend) {
    final List<Map<String, dynamic>> updatedSelection =
        List.from(widget.selectedFriends);
    updatedSelection.removeWhere((selected) => selected["id"] == friend["id"]);
    widget.onFriendsSelected(updatedSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'group',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Invite Friends',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                const Spacer(),
                if (widget.selectedFriends.isNotEmpty)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.selectedFriends.length}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 3.h),

            // Search bar
            TextField(
              controller: _searchController,
              onChanged: _filterFriends,
              decoration: InputDecoration(
                hintText: 'Search friends...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.textMediumEmphasisLight,
                  size: 20,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              ),
            ),

            SizedBox(height: 2.h),

            // Selected friends chips
            if (widget.selectedFriends.isNotEmpty) ...[
              Text(
                'Selected Friends',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: widget.selectedFriends.map((friend) {
                  return Chip(
                    avatar: CircleAvatar(
                      backgroundImage: NetworkImage(friend["avatar"] as String),
                      radius: 12,
                    ),
                    label: Text(
                      friend["name"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    deleteIcon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textMediumEmphasisLight,
                      size: 16,
                    ),
                    onDeleted: () => _removeFriend(friend),
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary
                        .withOpacity(0.1),
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withOpacity(0.3),
                      style: BorderStyle.solid,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 2.h),
            ],

            // Friends list
            Text(
              'All Friends',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            Container(
              constraints: BoxConstraints(
                maxHeight: 30.h,
              ),
              child: filteredFriends.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'search_off',
                              color: AppTheme.textMediumEmphasisLight,
                              size: 32,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'No friends found',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.textMediumEmphasisLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredFriends.length,
                      itemBuilder: (context, index) {
                        final friend = filteredFriends[index];
                        final isSelected = _isFriendSelected(friend);

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(friend["avatar"] as String),
                                radius: 20,
                              ),
                              if (friend["isOnline"] as bool)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: AppTheme.successLight,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme
                                            .lightTheme.scaffoldBackgroundColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Text(
                            friend["name"] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                friend["username"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppTheme.textMediumEmphasisLight,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'HCP ${friend["handicap"]}',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (value) =>
                                _toggleFriendSelection(friend),
                            activeColor:
                                AppTheme.lightTheme.colorScheme.primary,
                          ),
                          onTap: () => _toggleFriendSelection(friend),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
