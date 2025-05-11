import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project/firestoreServices/fetchTeamData.dart'; // <-- Import CoachService from here

class TeamSheet extends StatelessWidget {
  final String teamName;
  final String logoUrl;

  const TeamSheet({super.key, required this.teamName, required this.logoUrl});

  Future<Map<String, List<Map<String, dynamic>>>> fetchPlayersByRole() async {
    final teamsSnapshot =
        await FirebaseFirestore.instance.collection('teams').get();

    final teamDoc = teamsSnapshot.docs.firstWhere(
      (doc) =>
          (doc.data()['TeamName'] ?? '').toString().toLowerCase() ==
          teamName.toLowerCase(),
      orElse: () => throw Exception('Team not found'),
    );

    final membersSnapshot = await teamDoc.reference.collection('Members').get();

    final Map<String, List<Map<String, dynamic>>> roles = {
      "Goalkeepers": [],
      "Defenders": [],
      "Midfielders": [],
      "Forwards": [],
    };

    for (final doc in membersSnapshot.docs) {
      final data = doc.data();
      final roleRaw = (data['Role'] ?? '').toString().toLowerCase();

      if (roleRaw.contains('goal')) {
        roles['Goalkeepers']!.add(data);
      } else if (roleRaw.contains('defend')) {
        roles['Defenders']!.add(data);
      } else if (roleRaw.contains('mid')) {
        roles['Midfielders']!.add(data);
      } else if (roleRaw.contains('forward') || roleRaw.contains('striker')) {
        roles['Forwards']!.add(data);
      }
    }

    return roles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Row(
          children: [
            Image.network(logoUrl, width: 32, height: 32, fit: BoxFit.cover),
            const SizedBox(width: 10),
            Text(teamName, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: fetchPlayersByRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData ||
              snapshot.data!.values.every((list) => list.isEmpty)) {
            return Center(
              child: Text(
                "No players found",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          final roles = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Coach Section
                FutureBuilder<Map<String, dynamic>?>(
                  future: CoachService.fetchCoachByTeam(teamName),
                  builder: (context, coachSnapshot) {
                    if (coachSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (!coachSnapshot.hasData) return const SizedBox.shrink();

                    final coach = coachSnapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: Text(
                              'Coach',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                coach['image'] ?? '',
                              ),
                            ),
                            title: Text(
                              coach['CoachName'] ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
                // Players by Role
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        roles.entries.where((e) => e.value.isNotEmpty).map((
                          entry,
                        ) {
                          final role = entry.key;
                          final players = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                child: Text(
                                  role,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children:
                                    players.map((player) {
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.42,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 14,
                                              backgroundImage: NetworkImage(
                                                player['picture'] ?? '',
                                              ),
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                player['Name'] ?? '',
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
