import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:grad_project/screens/signinOptions/chooseFavTeam.dart';
import 'package:grad_project/providers/favoritesProvider.dart';
import 'package:grad_project/teamsData/allTeamsScreen.dart';
import 'package:grad_project/teamsData/coaches.dart';
import 'package:grad_project/teamsData/teamSheet.dart';
import 'package:grad_project/widgets/buildDrawer.dart';

class MorePage extends ConsumerStatefulWidget {
  const MorePage({super.key});

  @override
  ConsumerState<MorePage> createState() => _MorePageState();
}

class _MorePageState extends ConsumerState<MorePage> {
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
        title: Text('More', style: Theme.of(context).textTheme.titleLarge),
      ),
      drawer: BuildDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedTeams.length > 1
                      ? "Favourite Teams:"
                      : "Favourite Team:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 8),
                ...selectedTeams.map((teamName) {
                  final teamData = teams.firstWhere(
                    (team) => team['name'] == teamName,
                    orElse: () => {'name': teamName, 'image': ''},
                  );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (ctx) => TeamSheet(
                                  teamName: teamData['name']!,
                                  logoUrl: teamData['image']!,
                                ),
                          ),
                        );
                      },

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          children: [
                            if (teamData['image']!.isNotEmpty)
                              Image.network(
                                teamData['image']!,
                                width: 40,
                                height: 40,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        Icon(Icons.error),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                teamData['name']!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (ctx) => ChooseFavTeam(),
                                  ),
                                );
                              },
                              child: Text(
                                "Edit",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 24),
                Text(
                  "Football & More:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 8),
                _listItem("Watch Live", () {}),
                _listItem("Videos", () {}),
                _listItem("Teams", () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (ctx) => AllTeamsScreen()));
                }),

                _listItem("Coaches", () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (ctx) => CoachesPage()));
                }),
                _listItem("Players", () {}),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 1,
                  ),
                ),

                Text(
                  "Settings:",
                  style: Theme.of(context).textTheme.bodyLarge
                ),
                SizedBox(height: 8),
                _listItem("Notifications", () {}),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 1,
                  ),
                ),

                Text("Other:", style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(height: 8),
                _listItem("Contact Us", () {}),
                _listItem("Send Email", () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _listItem(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.secondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
