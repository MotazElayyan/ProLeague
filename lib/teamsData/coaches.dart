import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grad_project/models/coachCard.dart';
import 'package:grad_project/models/coachItem.dart';

class CoachesPage extends StatelessWidget {
  const CoachesPage({super.key});

  Future<List<Coach>> fetchCoaches() async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('coaches')
              .doc('coaches')
              .get();

      if (!docSnapshot.exists) {
        print('Document does not exist');
        return [];
      }

      final data = docSnapshot.data();

      if (data == null || data['team-coaches'] == null) return [];

      final List<dynamic> coachesList = data['team-coaches'];

      return coachesList
          .whereType<Map<String, dynamic>>()
          .map((coachMap) => Coach.fromMap(coachMap))
          .toList();
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
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: coaches.map((coach) => CoachCard(coach)).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
