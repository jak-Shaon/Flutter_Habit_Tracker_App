import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final style = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: style.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Theme Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Toggle light/dark theme instantly'),
                    value: theme.isDark,
                    onChanged: (_) => theme.toggle(),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.color_lens_outlined),
                    title: const Text('Theme Color'),
                    subtitle: Text(theme.isDark ? 'Black & Blue' : 'Blue & White'),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Demo Notifications Settings
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Daily Reminders'),
                    subtitle: const Text('Receive notifications for your habits'),
                    value: true,
                    onChanged: (v) {},
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Motivational Quotes Notifications'),
                    value: false,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Demo Account Settings
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Change Password'),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text('Log Out'),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Text(
              'Settings are stored locally and changes apply instantly.',
              style: style.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
