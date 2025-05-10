import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grad_project/models/coachItem.dart';
import 'package:grad_project/models/coachCard.dart';

class CoachesPage extends StatelessWidget {
  const CoachesPage({super.key});

  Future<List<Coach>> fetchCoaches() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Coaches').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        print("Fetched coach: $data");
        return Coach.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching coaches: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Team Coaches'),
      ),
      body: FutureBuilder<List<Coach>>(
        future: fetchCoaches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading coaches',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final coaches = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: coaches.map((coach) => CoachCard(coach)).toList(),
            ),
          );
        },
      ),
    );
  }
}
