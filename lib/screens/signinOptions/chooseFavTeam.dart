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
    {
      'name': 'Al Jazeera',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/Al_Jazeera_Club.png?alt=media&token=136d0a4d-2a81-4a78-87e3-299d4d067d0b',
    },
    {
      'name': 'Shabab Al Ordon',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/Shabab%20Al-Ordon%20logo.png?alt=media&token=df13011f-3b04-4bf7-940c-0bba003bdc64',
    },
    {
      'name': 'Al Faisaly',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/Al-Faisaly%20logo.png?alt=media&token=ada59c26-f829-49de-99d8-726364d36f79',
    },
    {
      'name': 'Al Wehdat',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/Al-Wehdat_SC__logo.png?alt=media&token=76935a2b-bf27-4e18-a0fd-67f661a1645b',
    },
    {
      'name': 'Al Hussein',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/ESC_AL-HUSSEIN_S.C.-removebg-preview.png?alt=media&token=1e932165-ce8a-4d0a-907f-fe3133a3b373',
    },
    {
      'name': 'Al Ramtha',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/Al-Ramtha_SC_Logo.png?alt=media&token=5c70f3fc-58ae-4318-b3db-9a4fcd49429b',
    },
    {
      'name': 'Moghayer Al Sarhan',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/Logo_of_Moghayer_Al-Sarhan_SC.png?alt=media&token=64ea8db1-ce4f-4237-b138-9bfe4c500cf4',
    },
    {
      'name': 'Maan',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/Ma_an_SC_logo.png?alt=media&token=145a4c9e-48ca-4497-9557-158e8bc7eef6',
    },
    {
      'name': 'Al Salt',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/Al-Salt%20logo.png?alt=media&token=9c175855-b402-4d7c-b348-bb6d4243d935',
    },
    {
      'name': 'Shabab Al Aqaba',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/Shabab_Al-Aqaba_Club_Logo.png?alt=media&token=05340d05-bbda-446c-9e64-e62ebe2cdb27',
    },
    {
      'name': 'Al Sareeh',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/Al-Sareeh%20logo.png?alt=media&token=6ac00ee1-5727-481c-9f6d-ab6428795d57',
    },
    {
      'name': 'Al Ahli',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/grad-project-2cd2d.firebasestorage.app/o/Al-Ahli%20logo.png?alt=media&token=bbdb8dc7-695a-4f86-ab67-2a808d0bce38',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedTeams = ref.watch(favoriteTeamsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                                child: Image.network(
                                  team['image']!,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(Icons.error),
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
