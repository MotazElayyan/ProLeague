import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grad_project/firestoreServices/firestoreHelper.dart';

class CoachService {
  static Future<List<Map<String, dynamic>>> fetchAllCoaches() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Coaches').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching coaches: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> fetchCoachByTeam(String teamName) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Coaches').get();

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        if ((data['TeamName'] ?? '').toString().toLowerCase() == teamName.toLowerCase()) {
          return data;
        }
      }

      print('No coach found for team: $teamName');
      return null;
    } catch (e) {
      print('Error fetching coach for team $teamName: $e');
      return null;
    }
  }
}

class TeamService {
  static Future<Map<String, List<Map<String, dynamic>>>> fetchPlayersByRole(String teamName) async {
    try {
      final teamsSnapshot = await FirebaseFirestore.instance.collection('teams').get();

      final teamDoc = teamsSnapshot.docs.firstWhere(
        (doc) {
          final fetchedName = (doc.data()['TeamName'] ?? '').toString().toLowerCase().trim();
          return fetchedName.isNotEmpty && fetchedName.contains(teamName.toLowerCase().trim());
        },
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
        final roleRaw = (FirestoreHelper.getField(data, 'Role') ?? '').toLowerCase();

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
    } catch (e) {
      print('Error fetching players for team $teamName: $e');
      return {
        "Goalkeepers": [],
        "Defenders": [],
        "Midfielders": [],
        "Forwards": [],
      };
    }
  }
}