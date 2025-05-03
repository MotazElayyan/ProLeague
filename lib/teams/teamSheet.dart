import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamSheet extends StatelessWidget {
  final String teamName;
  final String logoUrl;
  const TeamSheet({super.key, required this.teamName, required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    final teamRef = FirebaseFirestore.instance
        .collection('Teams')
        .doc(teamName);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(title: Text(teamName)),
      body: FutureBuilder<DocumentSnapshot>(
        future: teamRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Team not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final members = List<Map<String, dynamic>>.from(
            data['team members'] ?? 'Team not found',
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...['Goalkeeper', 'Defender', 'Midfielder', 'Striker'].map((
                role,
              ) {
                final filtered =
                    members.where((m) => m['Role'] == role).toList();
                if (filtered.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role + 's',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...filtered.map(
                      (member) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(member['picture']),
                        ),
                        title: Text(member['Name']),
                        subtitle: Text(member['Country']),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
