import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamSheet extends StatelessWidget {
  final String teamName;
  final String logoUrl;

  const TeamSheet({super.key, required this.teamName, required this.logoUrl});

  Future<Map<String, List<Map<String, dynamic>>>> fetchPlayersByRole() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('teams')
            .doc(teamName)
            .get();
    final data = doc.data();

    final Map<String, List<Map<String, dynamic>>> roles = {
      "Coach": [],
      "Goalkeeper": [],
      "Defender": [],
      "Midfielder": [],
      "Striker": [],
      "Forward": [],
    };

    if (data != null && data.containsKey('team')) {
      final team = data['team'];
      final members = team['members'] as Map<String, dynamic>;

      members.forEach((uid, memberData) {
        final player = memberData as Map<String, dynamic>;
        final roleRaw = player['Role']?.toString().toLowerCase() ?? '';

        if (roleRaw.contains('coach')) {
          roles["Coach"]!.add(player);
        } else if (roleRaw.contains('goal')) {
          roles["Goalkeeper"]!.add(player);
        } else if (roleRaw.contains('defend')) {
          roles["Defender"]!.add(player);
        } else if (roleRaw.contains('mid')) {
          roles["Midfielder"]!.add(player);
        } else if (roleRaw.contains('forward')) {
          roles["Forward"]!.add(player);
        } else if (roleRaw.contains('striker')) {
          roles["Striker"]!.add(player);
        }
      });
    }

    return roles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(title: Text(teamName)),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: fetchPlayersByRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No players found"));
          }

          final roles = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children:
                roles.entries.map((entry) {
                  final role = entry.key;
                  final players = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${role}s',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      ...players.map(
                        (player) => Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(player['picture']),
                            ),
                            title: Text(player['Name']),
                            subtitle: Text(player['Country']),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
