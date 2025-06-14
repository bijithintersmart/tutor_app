import 'package:flutter/material.dart';
import 'package:tutor_app/core/common_widget/info_screen.dart';
import 'package:tutor_app/core/db/supabase_client.dart';
import 'package:tutor_app/features/auth/data/models/user.dart';
import 'package:tutor_app/features/settings/presentation/pages/settings.dart';

class CustomDrawer extends StatefulWidget {
  final String userName;
  final String userEmail;
  final UserType? role;

  const CustomDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    this.role,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final client = SupabaseClientService();
  @override
  Widget build(BuildContext context) {
    final initials =
        widget.userName.isNotEmpty
            ? widget.userName.split(' ').map((e) => e[0]).take(2).join()
            : 'U';
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              widget.userName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            accountEmail: Text(
              widget.userEmail,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            currentAccountPicture: Material(
              elevation: 3,
              shape: CircleBorder(),
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Text(
                  initials,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Profile',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => TeacherProfileScreen(),
                  //   ),
                  // );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.privacy_tip,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Privacy Policy',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const InfoScreen(title: 'Privacy Policy'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.description,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Terms of Service',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const InfoScreen(title: 'Terms of Service'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'About Us',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InfoScreen(title: 'About Us'),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Logout',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await SupabaseClientService().signOut();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
