import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:grad_project/providers/themeProvider.dart';
import 'package:grad_project/screens/pages/landingPage.dart';
import 'package:grad_project/screens/pages/profilePage.dart';

class BuildDrawer extends ConsumerStatefulWidget {
  const BuildDrawer({super.key});

  @override
  ConsumerState<BuildDrawer> createState() => _BuildDrawerState();
}

class _BuildDrawerState extends ConsumerState<BuildDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              'Profile',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 236, 40, 26),
            ),
            title: Text(
              'Log Out',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 18,
                color: const Color.fromARGB(255, 236, 40, 26),
              ),
            ),
            onTap: () async {
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => LandingPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            title: Text(
              'Mode (Dark/Light)',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onTap: () {
              final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
              ref.read(themeModeProvider.notifier).state = newMode;
            },
          ),
        ],
      ),
    );
  }
}
