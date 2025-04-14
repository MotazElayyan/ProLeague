/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlayersTest extends StatefulWidget {
  const PlayersTest({super.key});

  @override
  State<PlayersTest> createState() => _PlayersTestState();
}

class _PlayersTestState extends State<PlayersTest> {
  void _getTeams() async {
    final user = FirebaseAuth.instance.currentUser!;
    final TeamsData =
        await FirebaseFirestore.instance
            .collection('Al Hussein')
            .doc(user.uid)
            .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Players Test')),
      body: Center(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('Al Hussein').snapshots(),
          builder: (ctx, chatSnapshots) {
            if (chatSnapshots.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
              return const Text('No data');
            }
            if (chatSnapshots.hasError) {
              return Text('Error: ${chatSnapshots.error}');
            }
            final loadedMessages = chatSnapshots.data!.docs;
            return ListView.builder(
              itemCount: loadedMessages.length,
              itemBuilder:
                  (ctx, index) =>
                      Text(loadedMessages[index].data()['Team members'][0].toString()),
            );
          },
        ),
      ),
    );
  }
}*/
