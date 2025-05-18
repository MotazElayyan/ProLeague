import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlayerAwardsScreen extends StatelessWidget {
  const PlayerAwardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          'Player Awards',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('Awards')
                .where('AwardType', isEqualTo: 'Player')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var awards = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: awards.length,
            itemBuilder: (context, index) {
              var award = awards[index];
              return Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      award['PlayerPicture'],
                    ),
                  ),
                  title: Text(
                    award['PlayerName'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    award['AwardName'],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Team: ${award['TeamName']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Season: ${award['Season']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
