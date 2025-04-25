import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayersTest extends StatefulWidget {
  const PlayersTest({super.key});

  @override
  State<PlayersTest> createState() => _PlayersTestState();
}

class _PlayersTestState extends State<PlayersTest> {
  Map<String, dynamic>? teamData;

  Future<void> getData() async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance
              .collection('Teams')
              .doc('Al Ahli')
              .get();

      if (documentSnapshot.exists) {
        setState(() {
          teamData = documentSnapshot.data() as Map<String, dynamic>?;
        });
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      print("Error fetching document: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final teamMembers = teamData?['Team members'] as List<dynamic>?;

    return Scaffold(
      appBar: AppBar(title: const Text('Players Test')),
      body:
          teamMembers == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: teamMembers.length,
                itemBuilder: (ctx, index) {
                  final member = teamMembers[index] as Map<String, dynamic>;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Image.asset('assets/images/logo1.png', height: 100),
                          Text(member['Name'] ?? 'No name'),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
