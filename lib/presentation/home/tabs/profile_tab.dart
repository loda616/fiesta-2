import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: theme.colorScheme.primary,
            child: const Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            'Username',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          _ProfileMenuItem(
            icon: Icons.movie_outlined,
            title: 'Watched Movies',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.logout_outlined,
            title: 'Logout',
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
