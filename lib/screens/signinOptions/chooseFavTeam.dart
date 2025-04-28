import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:grad_project/models/elevatedButton.dart';
import 'package:grad_project/providers/favoritesProvider.dart';
import 'package:grad_project/widgets/tabs.dart';

class ChooseFavTeam extends ConsumerStatefulWidget {
  const ChooseFavTeam({super.key});

  @override
  ConsumerState<ChooseFavTeam> createState() => _ChooseFavTeamState();
}

class _ChooseFavTeamState extends ConsumerState<ChooseFavTeam> {
  bool _isSaving = false;

  void _start() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (ctx) => Tabs()));
  }

  void _toggleSelection(String team) {
    ref.read(favoriteTeamsProvider.notifier).toggleTeam(team);
  }

  Future<void> saveFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final selectedTeams = ref.read(favoriteTeamsProvider);

    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final username = userDoc.data()?['username'] ?? 'Unknown';

      await FirebaseFirestore.instance
          .collection('favorite_teams')
          .doc(user.uid)
          .set({
            'userId': user.uid,
            'username': username,
            'teams': selectedTeams.toList(),
            'timestamp': FieldValue.serverTimestamp(),
          });
      _start();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save favorites')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  final List<Map<String, String>> teams = [
    {'name': 'Al Jazeera', 'image': 'assets/images/AlJazeera.png'},
    {'name': 'Shabab Al Ordon', 'image': 'assets/images/ShababJ.png'},
    {'name': 'Al Faisaly', 'image': 'assets/images/Faisaly.png'},
    {'name': 'Al Wehdat', 'image': 'assets/images/Wehdat.png'},
    {'name': 'Al Hussein', 'image': 'assets/images/Hussain.gif'},
    {'name': 'Al Ramtha', 'image': 'assets/images/Ramtha.png'},
    {'name': 'Moghayer Al Sarhan', 'image': 'assets/images/Moghayer.png'},
    {'name': 'Maan', 'image': 'assets/images/maan.png'},
    {'name': 'Al Salt', 'image': 'assets/images/Salt.png'},
    {'name': 'Shabab Al Aqaba', 'image': 'assets/images/ShababA.png'},
    {'name': 'Al Sareeh', 'image': 'assets/images/Sareeh.png'},
    {'name': 'Al Ahli', 'image': 'assets/images/Ahli.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedTeams = ref.watch(favoriteTeamsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Choose Your Favorite Team'),
        actions: [
          TextButton(
            onPressed: _start,
            child: Text(
              'Skip >',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: teams.length,
                  itemBuilder: (ctx, index) {
                    final team = teams[index];
                    final isSelected = selectedTeams.contains(team['name']);

                    return GestureDetector(
                      onTap: () => _toggleSelection(team['name']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white24,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                isSelected ? Colors.white : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  team['image']!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              team['name']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child:
                  _isSaving
                      ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      )
                      : CustomElevatedButton(
                        title: 'Continue >',
                        onPressed: saveFavorites,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
