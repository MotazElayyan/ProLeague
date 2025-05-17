import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:grad_project/firestoreServices/firestoreHelper.dart';

class CoachService {
  static Future<List<Map<String, dynamic>>> fetchAllCoaches() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Coaches').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching coaches: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> fetchCoachByTeam(String teamName) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Coaches').get();

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        if ((data['TeamName'] ?? '').toString().toLowerCase() ==
            teamName.toLowerCase()) {
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
  static Future<Map<String, List<Map<String, dynamic>>>> fetchPlayersByRole(
    String teamName,
  ) async {
    try {
      final teamsSnapshot =
          await FirebaseFirestore.instance.collection('teams').get();

      final teamDoc = teamsSnapshot.docs.firstWhere((doc) {
        final fetchedName =
            (doc.data()['TeamName'] ?? '').toString().toLowerCase().trim();
        return fetchedName.isNotEmpty &&
            fetchedName.contains(teamName.toLowerCase().trim());
      }, orElse: () => throw Exception('Team not found'));

      final membersSnapshot =
          await teamDoc.reference.collection('Members').get();

      final Map<String, List<Map<String, dynamic>>> roles = {
        "Goalkeepers": [],
        "Defenders": [],
        "Midfielders": [],
        "Forwards": [],
      };

      for (final doc in membersSnapshot.docs) {
        final data = doc.data();
        final roleRaw =
            (FirestoreHelper.getField(data, 'Role') ?? '').toLowerCase();

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

class FixtureService {
  /// Fetch fixtures for a specific team from Firestore
  static Future<List<Map<String, dynamic>>> fetchFixtures(
    String teamName,
  ) async {
    try {
      // Step 1: Find the team document in 'fixtures' collection
      final teamDocSnapshot =
          await FirebaseFirestore.instance
              .collection('fixtures')
              .where('TeamName', isEqualTo: teamName)
              .get();

      if (teamDocSnapshot.docs.isEmpty) {
        print('No fixtures document found for $teamName');
        return [];
      }

      final teamDocId = teamDocSnapshot.docs.first.id;

      // Step 2: Fetch fixtures from subcollection 'TeamFixtures'
      final fixturesSnapshot =
          await FirebaseFirestore.instance
              .collection('fixtures')
              .doc(teamDocId)
              .collection('TeamFixtures')
              .get();

      // Step 3: Format and return fixtures data
      return fixturesSnapshot.docs.map((doc) {
        final data = doc.data();

        if (data['DateTime'] is Timestamp) {
          final timestamp = data['DateTime'] as Timestamp;
          data['DateTime'] = DateFormat(
            'd MMM yyyy • hh:mm a',
          ).format(timestamp.toDate());
        }

        return data;
      }).toList();
    } catch (e) {
      print('Error fetching fixtures for $teamName: $e');
      return [];
    }
  }

  /// Fetch results for a specific team from Firestore
  static Future<List<Map<String, dynamic>>> fetchResults(
    String teamName,
  ) async {
    try {
      final resultsDoc =
          await FirebaseFirestore.instance
              .collection('Results')
              .doc(teamName)
              .get();

      if (!resultsDoc.exists) {
        print('No results document found for $teamName');
        return [];
      }

      final rawResults = resultsDoc.data()?['teamResults'] as List<dynamic>?;

      if (rawResults == null || rawResults.isEmpty) {
        print('No results found in teamResults array for $teamName');
        return [];
      }

      // Map and format results
      return rawResults.map<Map<String, dynamic>>((result) {
        final data = Map<String, dynamic>.from(result);

        if (data['dateTime'] is Timestamp) {
          final timestamp = data['dateTime'] as Timestamp;
          data['dateTime'] = DateFormat(
            'd MMM yyyy • hh:mm a',
          ).format(timestamp.toDate());
        }

        return data;
      }).toList();
    } catch (e) {
      print('Error fetching results for $teamName: $e');
      return [];
    }
  }
}
