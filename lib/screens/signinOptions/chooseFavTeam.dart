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
  final Set<String> selectedTeams = {};
  bool _isSaving = false;

  void _start() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (ctx) => Tabs()));
  }

  void _toggleSelection(String team) {
    ref.read(favoriteTeamsProvider.notifier).toggleTeam(team);
    setState(() {
      if (selectedTeams.contains(team)) {
        selectedTeams.remove(team);
      } else {
        selectedTeams.add(team);
      }
    });
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

    try {
      await FirebaseFirestore.instance
          .collection('favorite_teams')
          .doc(user.uid)
          .set({
            'userId': user.uid,
            'teams': selectedTeams.toList(),
            'timestamp': FieldValue.serverTimestamp(),
          });
      print("Favorites saved successfully");
      _start();
    } catch (e) {
      print("Failed to save favorites: $e");
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

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Choose Your Favorite Team'),
        actions: [
          TextButton(
            onPressed: _start,
            child: const Text(
              'Skip >',
              style: TextStyle(color: Colors.white, fontSize: 16),
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
                      ? const CircularProgressIndicator(color: Colors.white)
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
