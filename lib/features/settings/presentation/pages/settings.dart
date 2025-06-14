import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../bloc/settings_bloc.dart';
import '../bloc/settings_state.dart';

// Assuming SettingsBloc, SettingsState, and SettingsEvent are defined as in the previous response
// Import the SettingsBloc file (adjust the path as needed)
// import 'path_to_settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          systemOverlayStyle:
              isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  _buildProfileSection(context),
                  const SizedBox(height: 24),

                  // Notifications Section
                  _buildSectionTitle(context, 'Notifications'),
                  _buildSettingsCard(context, [
                    _buildSwitchTile(
                      context,
                      icon: Icons.notifications_outlined,
                      title: 'Push Notifications',
                      subtitle: 'Receive push notifications',
                      value: state.pushNotifications,
                      onChanged:
                          (value) => context.read<SettingsBloc>().add(
                            UpdatePushNotifications(enabled: value),
                          ),
                    ),
                    _buildDivider(context),
                    _buildSwitchTile(
                      context,
                      icon: Icons.email_outlined,
                      title: 'Email Notifications',
                      subtitle: 'Receive email updates',
                      value: state.emailNotifications,
                      onChanged:
                          (value) => context.read<SettingsBloc>().add(
                            UpdateEmailNotifications(enabled: value),
                          ),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Theme & Appearance Section
                  _buildSectionTitle(context, 'Theme & Appearance'),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      context,
                      icon: Icons.palette_outlined,
                      title: 'Theme',
                      subtitle: _themeToString(state.themeMode),
                      onTap: () => _showThemeSelector(context),
                    ),
                    _buildDivider(context),
                    _buildListTile(
                      context,
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: _mapLanguageToDisplay(state.language),
                      onTap: () => _showLanguageSelector(context),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Security Section
                  _buildSectionTitle(context, 'Security & Privacy'),
                  _buildSettingsCard(context, [
                    _buildSwitchTile(
                      context,
                      icon: Icons.fingerprint_outlined,
                      title: 'Biometric Authentication',
                      subtitle: 'Use fingerprint or face ID',
                      value: state.biometricAuth,
                      onChanged:
                          (value) => context.read<SettingsBloc>().add(
                            UpdateBiometricAuth(enabled: value),
                          ),
                    ),
                    _buildDivider(context),
                    _buildListTile(
                      context,
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your password',
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                    _buildDivider(context),
                    _buildListTile(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'View privacy policy',
                      onTap: () => _openPrivacyPolicy(context),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // App Updates Section
                  _buildSectionTitle(context, 'App Updates'),
                  _buildSettingsCard(context, [
                    _buildSwitchTile(
                      context,
                      icon: Icons.system_update_outlined,
                      title: 'Auto Updates',
                      subtitle: 'Download updates automatically',
                      value: state.autoUpdate,
                      onChanged:
                          (value) => context.read<SettingsBloc>().add(
                            UpdateAutoUpdate(enabled: value),
                          ),
                    ),
                    _buildDivider(context),
                    _buildListTile(
                      context,
                      icon: Icons.download_outlined,
                      title: 'Check for Updates',
                      subtitle: 'Manually check for updates',
                      onTap: () => _checkForUpdates(context),
                      trailing: _buildUpdateBadge(context),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Storage & Data Section
                  _buildSectionTitle(context, 'Storage & Data'),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      context,
                      icon: Icons.storage_outlined,
                      title: 'Storage Usage',
                      subtitle: '2.4 GB used',
                      onTap: () => _showStorageDetails(context),
                    ),
                    _buildDivider(context),
                    _buildListTile(
                      context,
                      icon: Icons.clear_outlined,
                      title: 'Clear Cache',
                      subtitle: 'Free up storage space',
                      onTap: () => _clearCache(context),
                    ),
                    _buildDivider(context),
                    _buildListTile(
                      context,
                      icon: Icons.backup_outlined,
                      title: 'Backup & Sync',
                      subtitle: 'Manage your data backup',
                      onTap: () => _openBackupSettings(context),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Support Section
                  _buildSectionTitle(context, 'Support & Feedback'),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      context,
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help and contact support',
                      onTap: () => _openSupport(context),
                    ),
                    _buildDivider(context),
                    _buildListTile(
                      context,
                      icon: Icons.feedback_outlined,
                      title: 'Send Feedback',
                      subtitle: 'Share your thoughts with us',
                      onTap: () => _sendFeedback(context),
                    ),
                    _buildDivider(context),
                    _buildListTile(
                      context,
                      icon: Icons.star_outline,
                      title: 'Rate the App',
                      subtitle: 'Rate us on the App Store',
                      onTap: () => _rateApp(context),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // About Section
                  _buildSectionTitle(context, 'About'),
                  _buildSettingsCard(context, [
                    _buildListTile(
                      context,
                      icon: Icons.info_outline,
                      title: 'App Version',
                      subtitle: '1.2.3 (Build 45)',
                      onTap: () => _showVersionDetails(context),
                    ),
                    _buildDivider(context),
                    _buildListTile(
                      context,
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      subtitle: 'View terms and conditions',
                      onTap: () => _openTermsOfService(context),
                    ),
                    _buildDivider(context),
                    _buildListTile(
                      context,
                      icon: Icons.logout,
                      title: 'Sign Out',
                      subtitle: 'Sign out of your account',
                      onTap: () => _signOut(context),
                      titleColor: colorScheme.error,
                    ),
                    _buildDivider(context),
                    _buildListTile(
                      context,
                      icon: Icons.restart_alt_outlined,
                      title: 'Reset Settings',
                      subtitle: 'Restore default settings',
                      onTap:
                          () =>
                              context.read<SettingsBloc>().add(ResetSettings()),
                      titleColor: colorScheme.error,
                    ),
                  ]),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 30,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _editProfile(context),
            icon: const Icon(Icons.edit_outlined),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? titleColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: titleColor ?? colorScheme.onSurface,
        ),
      ),
      subtitle:
          subtitle != null
              ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              )
              : null,
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle:
          subtitle != null
              ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              )
              : null,
      trailing: Switch(value: value, onChanged: onChanged),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Divider(
      height: 1,
      indent: 60,
      endIndent: 16,
      color: colorScheme.outline.withValues(alpha: 0.2),
    );
  }

  Widget _buildUpdateBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Up to date',
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Helper methods to map bloc state to UI display values
  String _mapLanguageToDisplay(String languageCode) {
    const languageMap = {
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
    };
    return languageMap[languageCode] ?? 'English';
  }

  String _mapLanguageToCode(String language) {
    const languageMap = {
      'English': 'en',
      'Spanish': 'es',
      'French': 'fr',
      'German': 'de',
    };
    return languageMap[language] ?? 'en';
  }

  ThemeMode _themeStringToTheme(String theme) {
    switch (theme) {
      case 'System':
        return ThemeMode.system;
      case 'Light':
        return ThemeMode.light;
      case 'Dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.dark;
    }
  }

  String _themeToString(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      }
  }

  // Action methods
  void _editProfile(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Edit profile functionality')));
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Theme',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                ...['System', 'Light', 'Dark'].map(
                  (theme) => RadioListTile.adaptive(
                    value: theme,
                    groupValue: _themeToString(
                      context.read<SettingsBloc>().state.themeMode,
                    ),
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        UpdateTheme(themeMode: _themeStringToTheme(value!)),
                      );
                      Navigator.pop(context);
                    },
                    title: Text(theme,style: Theme.of(context).textTheme.bodyMedium,),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Language',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                ...['English', 'Spanish', 'French', 'German'].map(
                  (language) => RadioListTile.adaptive(
                     value: language,
                    groupValue: _mapLanguageToDisplay(
                      context.read<SettingsBloc>().state.language,
                    ),
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        UpdateLanguage(language: _mapLanguageToCode(value!)),
                      );
                      Navigator.pop(context);
                    },
                    title: Text(language,style: Theme.of(context).textTheme.bodyMedium,),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Password'),
            content: const Text(
              'This will redirect you to the password change screen.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Proceed'),
              ),
            ],
          ),
    );
  }

  void _checkForUpdates(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Checking for Updates'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Please wait...'),
              ],
            ),
          ),
    );

    // Simulate update check
    Future.delayed(const Duration(seconds: 2), () {
      if(context.mounted){
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your app is up to date!')));
      }
    });
  }

  void _showVersionDetails(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('App Version'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Version: 1.2.3'),
                Text('Build: 45'),
                Text('Release Date: January 15, 2024'),
                SizedBox(height: 16),
                Text('What\'s New:'),
                Text('• Bug fixes and improvements'),
                Text('• Enhanced security features'),
                Text('• Better performance'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _signOut(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Implement sign out logic
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
    );
  }

  // Placeholder methods for other actions
  void _openPrivacyPolicy(BuildContext context) =>
      _showPlaceholderSnackBar(context, 'Privacy Policy');
  void _showStorageDetails(BuildContext context) =>
      _showPlaceholderSnackBar(context, 'Storage Details');
  void _clearCache(BuildContext context) =>
      _showPlaceholderSnackBar(context, 'Cache Cleared');
  void _openBackupSettings(BuildContext context) =>
      _showPlaceholderSnackBar(context, 'Backup Settings');
  void _openSupport(BuildContext context) =>
      _showPlaceholderSnackBar(context, 'Help & Support');
  void _sendFeedback(BuildContext context) =>
      _showPlaceholderSnackBar(context, 'Send Feedback');
  void _rateApp(BuildContext context) =>
      _showPlaceholderSnackBar(context, 'Rate App');
  void _openTermsOfService(BuildContext context) =>
      _showPlaceholderSnackBar(context, 'Terms of Service');

  void _showPlaceholderSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature functionality will be implemented')),
    );
  }
}
