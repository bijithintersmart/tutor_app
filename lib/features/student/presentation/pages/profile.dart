import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeaderWidget(),
              const SizedBox(height: 24),
              AccountSettingsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/women/11.jpg',
                ),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alex Johnson',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Computer Science Student',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 24),
                onPressed: () {},
                tooltip: 'Edit profile',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatCard(value: '24', label: 'Classes\nCompleted'),
              StatCard(value: '16', label: 'Hours\nSpent'),
              StatCard(value: '4.8', label: 'Average\nRating'),
            ],
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;

  const StatCard({Key? key, required this.value, required this.label})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class AccountSettingsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> settings = [
    {
      'title': 'Personal Information',
      'subtitle': 'Name, email, phone number',
      'icon': Icons.person_outline,
      'isLogout': false,
    },
    {
      'title': 'Privacy & Security',
      'subtitle': 'Password, 2FA, data settings',
      'icon': Icons.security,
      'isLogout': false,
    },
    {
      'title': 'Help & Support',
      'subtitle': 'Contact us with questions',
      'icon': Icons.help_outline,
      'isLogout': false,
    },
    {
      'title': 'Log Out',
      'subtitle': 'Sign out of your account',
      'icon': Icons.logout,
      'isLogout': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Settings',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Column(
            children:
                settings
                    .map(
                      (setting) => SettingsCard(
                        title: setting['title'],
                        subtitle: setting['subtitle'],
                        icon: setting['icon'],
                        isLogout: setting['isLogout'],
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isLogout;

  const SettingsCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isLogout = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isLogout
                    ? Colors.red.withOpacity(0.1)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color:
                isLogout ? Colors.red : Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: isLogout ? Colors.red : null,
          ),
        ),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right, size: 24),
        onTap: () {},
      ),
    );
  }
}
