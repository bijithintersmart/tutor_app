import 'package:flutter/material.dart';
import 'package:tutor_app/core/common_widget/info_screen.dart';
import 'package:tutor_app/core/db/supabase_client.dart';
import 'package:tutor_app/features/auth/data/models/user.dart';
import 'package:tutor_app/features/manager/presentation/pages/manager_screen.dart';
import 'package:tutor_app/features/teacher/presentation/pages/teacher_leave_request.dart';

import 'made_with_flutter.dart';

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

  // Widget get profile => role == UserType.teacher? TeacherProfileScreen(teacher: Teacher(id: id, name: name, email: email, subjects: subjects, availability: availability), selectedDate: selectedDate):role ==UserType.manager? ManagerProfile():StudentAssignment();
  @override
  Widget build(BuildContext context) {
    final initials =
        widget.userName.isNotEmpty
            ? widget.userName.split(' ').map((e) => e[0]).take(2).join()
            : 'U';
    // final user = client.currentUser;

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
            currentAccountPicture: CircleAvatar(
              radius: 36,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                initials,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.dashboard,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    'Manager Dashboard',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManagerDashboard(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.event,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    'Leave Requests',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeacherLeaveRequest(),
                      ),
                    );
                  },
                ),
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
                    //     builder: (context) =>  TeacherProfileScreen(),
                    //   ),
                    // );
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
                        builder:
                            (context) => const InfoScreen(title: 'About Us'),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Logout',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await SupabaseClientService().signOut();
                  },
                ),
              ],
            ),
          ),
          Spacer(flex: 1),
          MadeWithFlutter(),
        ],
      ),
    );
  }
}
