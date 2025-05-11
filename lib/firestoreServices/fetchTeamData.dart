import 'package:cloud_firestore/cloud_firestore.dart';

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
