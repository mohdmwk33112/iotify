import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme settings
          _SettingsSection(
            title: 'Appearance',
            children: [
              _SettingsTile(
                leading: const Icon(Icons.dark_mode),
                title: 'Dark Mode',
                trailing: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: AppTheme.primaryColor,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Notification settings
          _SettingsSection(
            title: 'Notifications',
            children: [
              _SettingsTile(
                leading: const Icon(Icons.power),
                title: 'Power Surge Alerts',
                trailing: Switch(
                  value: true, // This should be managed by state
                  onChanged: (value) {
                    // Handle power surge alerts toggle
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              _SettingsTile(
                leading: const Icon(Icons.analytics),
                title: 'Usage Reports',
                trailing: Switch(
                  value: true, // This should be managed by state
                  onChanged: (value) {
                    // Handle usage reports toggle
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Account settings
          _SettingsSection(
            title: 'Account',
            children: [
              _SettingsTile(
                leading: const Icon(Icons.person),
                title: 'Profile',
                onTap: () {
                  // Navigate to profile screen
                },
              ),
              _SettingsTile(
                leading: const Icon(Icons.security),
                title: 'Security',
                onTap: () {
                  // Navigate to security screen
                },
              ),
              _SettingsTile(
                leading: const Icon(Icons.help),
                title: 'Help & Support',
                onTap: () {
                  // Navigate to help screen
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // App info
          _SettingsSection(
            title: 'About',
            children: [
              const _SettingsTile(
                leading: Icon(Icons.info),
                title: 'Version',
                trailing: Text('1.0.0'),
              ),
              _SettingsTile(
                leading: const Icon(Icons.privacy_tip),
                title: 'Privacy Policy',
                onTap: () {
                  // Navigate to privacy policy
                },
              ),
              _SettingsTile(
                leading: const Icon(Icons.description),
                title: 'Terms of Service',
                onTap: () {
                  // Navigate to terms of service
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Sign out button
          ElevatedButton(
            onPressed: () {
              // Handle sign out
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.leading,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
} 