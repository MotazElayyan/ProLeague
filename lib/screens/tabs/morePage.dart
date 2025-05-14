import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad_project/screens/pages/tablePage.dart';

import 'package:grad_project/screens/pages/videosPage.dart';
import 'package:grad_project/screens/signinOptions/allowNotifications.dart';
import 'package:grad_project/screens/signinOptions/chooseFavTeam.dart';
import 'package:grad_project/providers/favoritesProvider.dart';
import 'package:grad_project/teamsData/allTeamsScreen.dart';
import 'package:grad_project/teamsData/coaches.dart';
import 'package:grad_project/teamsData/teamSheet.dart';
import 'package:grad_project/widgets/buildDrawer.dart';
import 'package:grad_project/teamsData/teamsList.dart';

class MorePage extends ConsumerStatefulWidget {
  const MorePage({super.key});

  @override
  ConsumerState<MorePage> createState() => _MorePageState();
}

class _MorePageState extends ConsumerState<MorePage> {
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
                _listItem("Videos", () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (ctx) => VideosPage()));
                }),
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
                _listItem("Table", () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (ctx) => TablePage()));
                }),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 1,
                  ),
                ),

                Text("Settings:", style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(height: 8),
                _listItem("Notifications", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => AllowNotifications()),
                  );
                }),

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
