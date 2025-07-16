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

  @override
  void initState() {
    super.initState();
    preferences = Map<String, dynamic>.from(
        widget.userData["preferences"] as Map<String, dynamic>);
  }

  void _showLogoutConfirmation() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to logout? You will need to sign in again to access your golf data.',
          style: theme.textTheme.bodyMedium,
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
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
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
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Privacy Settings',
              style: theme.textTheme.titleLarge?.copyWith(
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
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Export Golf Resume',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Generate a PDF with your golf statistics, achievements, and playing history.',
          style: theme.textTheme.bodyMedium,
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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.1),
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
    final theme = Theme.of(context);

    return ListTile(
      leading: iconName != null
          ? CustomIconWidget(
              iconName: iconName,
              color: theme.colorScheme.primary,
              size: 24,
            )
          : null,
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: trailing ??
          CustomIconWidget(
            iconName: 'chevron_right',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
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
    final theme = Theme.of(context);

    return ListTile(
      leading: iconName != null
          ? CustomIconWidget(
              iconName: iconName,
              color: theme.colorScheme.primary,
              size: 24,
            )
          : null,
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
    final theme = Theme.of(context);
    final themeManager = Provider.of<ThemeManager>(context);
    final distanceManager = Provider.of<DistanceUnitManager>(context);

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
            Divider(color: theme.dividerColor, height: 1),
            _buildSettingsTile(
              title: 'Linked Accounts',
              subtitle: (widget.userData["linkedAccounts"] as List).join(", "),
              iconName: 'link',
              onTap: () {},
            ),
            Divider(color: theme.dividerColor, height: 1),
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
              },
            ),
            Divider(color: theme.dividerColor, height: 1),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'dark_mode',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Dark Mode',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Use dark theme for better visibility',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              trailing: Switch(
                value: themeManager.isDarkMode,
                onChanged: (value) async {
                  await themeManager.setDarkMode(value);
                  setState(() {
                    preferences["darkMode"] = value;
                  });
                },
              ),
            ),
            Divider(color: theme.dividerColor, height: 1),
            Consumer<DistanceUnitManager>(
              builder: (context, distanceManager, child) {
                return ListTile(
                  leading: CustomIconWidget(
                    iconName: 'straighten',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  title: Text(
                    'Distance Units',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Switch between yards and metres',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  trailing: Switch(
                    value: distanceManager.isMetric,
                    onChanged: (value) async {
                      await distanceManager.setMetric(value);
                    },
                  ),
                );
              },
            ),
            Divider(color: theme.dividerColor, height: 1),
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
            Divider(color: theme.dividerColor, height: 1),
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
            Divider(color: theme.dividerColor, height: 1),
            _buildSettingsTile(
              title: 'Send Feedback',
              subtitle: 'Help us improve Loop Golf',
              iconName: 'feedback',
              onTap: () {},
            ),
            Divider(color: theme.dividerColor, height: 1),
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
                color: theme.colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Logout',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Sign out of your account',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
