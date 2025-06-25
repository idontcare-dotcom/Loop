import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const SettingsSectionWidget({
    super.key,
    required this.userData,
  });

  @override
  State<SettingsSectionWidget> createState() => _SettingsSectionWidgetState();
}

class _SettingsSectionWidgetState extends State<SettingsSectionWidget> {
  late Map<String, dynamic> preferences;

  final NotificationsService _notificationsService = NotificationsService();

  @override
  void initState() {
    super.initState();
    preferences = Map<String, dynamic>.from(
        widget.userData["preferences"] as Map<String, dynamic>);
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to logout? You will need to sign in again to access your golf data.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.textDisabledLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Privacy Settings',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildSettingsTile(
              title: 'Score Visibility',
              subtitle: 'Who can see your scores',
              trailing: DropdownButton<String>(
                value: preferences["scoreVisibility"] as String,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'public', child: Text('Public')),
                  DropdownMenuItem(
                      value: 'friends', child: Text('Friends Only')),
                  DropdownMenuItem(value: 'private', child: Text('Private')),
                ],
                onChanged: (value) {
                  setState(() {
                    preferences["scoreVisibility"] = value;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            _buildSwitchTile(
              title: 'Friend Discovery',
              subtitle: 'Allow others to find you',
              value: preferences["friendDiscovery"] as bool,
              onChanged: (value) {
                setState(() {
                  preferences["friendDiscovery"] = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Data Sharing',
              subtitle: 'Share anonymous data for improvements',
              value: preferences["dataSharing"] as bool,
              onChanged: (value) {
                setState(() {
                  preferences["dataSharing"] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _exportGolfResume() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Export Golf Resume',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Generate a PDF with your golf statistics, achievements, and playing history.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Generate and export PDF
            },
            child: const Text('Export PDF'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    String? iconName,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: iconName != null
          ? CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            )
          : null,
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textMediumEmphasisLight,
        ),
      ),
      trailing: trailing ??
          CustomIconWidget(
            iconName: 'chevron_right',
            color: AppTheme.textDisabledLight,
            size: 20,
          ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? iconName,
  }) {
    return ListTile(
      leading: iconName != null
          ? CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            )
          : null,
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textMediumEmphasisLight,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account Settings
        _buildSettingsGroup(
          title: 'ACCOUNT',
          children: [
            _buildSettingsTile(
              title: 'Account Information',
              subtitle: 'Update your profile details',
              iconName: 'person',
              onTap: () {},
            ),
            Divider(color: AppTheme.dividerLight, height: 1),
            _buildSettingsTile(
              title: 'Linked Accounts',
              subtitle:
                  (widget.userData["linkedAccounts"] as List).join(", "),
              iconName: 'link',
              onTap: () {},
            ),
            Divider(color: AppTheme.dividerLight, height: 1),
            _buildSettingsTile(
              title: 'Premium Subscription',
              subtitle: widget.userData["isPremium"] as bool
                  ? 'Active subscription'
                  : 'Upgrade for advanced features',
              iconName: 'star',
              onTap: () {},
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Preferences
        _buildSettingsGroup(
          title: 'PREFERENCES',
          children: [
            _buildSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Tee time reminders and score updates',
              iconName: 'notifications',
              value: preferences["notifications"] as bool,
              onChanged: (value) {
                setState(() {
                  preferences["notifications"] = value;
                });
                if (value) {
                  // TODO: Replace with actual notification integration
                  _notificationsService
                      .sendPushNotification('Notifications enabled');
                }
              },
            ),
            Divider(color: AppTheme.dividerLight, height: 1),
            _buildSwitchTile(
              title: 'Dark Mode',
              subtitle: 'Use dark theme for better visibility',
              iconName: 'dark_mode',
              value: preferences["darkMode"] as bool,
              onChanged: (value) {
                setState(() {
                  preferences["darkMode"] = value;
                });
              },
            ),
            Divider(color: AppTheme.dividerLight, height: 1),
            _buildSettingsTile(
              title: 'Privacy Settings',
              subtitle: 'Control your data visibility',
              iconName: 'privacy_tip',
              onTap: _showPrivacySettings,
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Data & Export
        _buildSettingsGroup(
          title: 'DATA & EXPORT',
          children: [
            _buildSettingsTile(
              title: 'Export Golf Resume',
              subtitle: 'Generate PDF with your statistics',
              iconName: 'file_download',
              onTap: _exportGolfResume,
            ),
            Divider(color: AppTheme.dividerLight, height: 1),
            _buildSettingsTile(
              title: 'Data Backup',
              subtitle: 'Backup your golf data to cloud',
              iconName: 'backup',
              onTap: () {},
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Support & About
        _buildSettingsGroup(
          title: 'SUPPORT',
          children: [
            _buildSettingsTile(
              title: 'Help & Support',
              subtitle: 'Get help with the app',
              iconName: 'help',
              onTap: () {},
            ),
            Divider(color: AppTheme.dividerLight, height: 1),
            _buildSettingsTile(
              title: 'Send Feedback',
              subtitle: 'Help us improve Loop Golf',
              iconName: 'feedback',
              onTap: () {},
            ),
            Divider(color: AppTheme.dividerLight, height: 1),
            _buildSettingsTile(
              title: 'About',
              subtitle: 'App version and information',
              iconName: 'info',
              onTap: () {},
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Logout
        _buildSettingsGroup(
          title: 'ACCOUNT ACTIONS',
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'logout',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: Text(
                'Logout',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.errorLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Sign out of your account',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
              ),
              onTap: _showLogoutConfirmation,
            ),
          ],
        ),
      ],
    );
  }
}
