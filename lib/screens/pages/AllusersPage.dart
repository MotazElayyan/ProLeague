import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project/core/widgets/chats.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser!.uid;
  }

  Future<Map<String, dynamic>> _getLastMessageAndUser(
    DocumentSnapshot userDoc,
  ) async {
    final userId = userDoc.id;
    final participants = [currentUserId, userId]..sort();
    final chatId = '${participants[0]}_${participants[1]}';

    final query =
        await _firestore
            .collection('messages')
            .doc(chatId)
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();

    Timestamp? lastTimestamp;
    String lastMessage = '';

    if (query.docs.isNotEmpty) {
      final msgData = query.docs.first.data();
      lastTimestamp = msgData['createdAt'];
      lastMessage = msgData['text'] ?? '';
    }

    return {
      'userDoc': userDoc,
      'lastMessage': lastMessage,
      'lastTimestamp': lastTimestamp,
    };
  }

  Future<List<Map<String, dynamic>>> _getUsersSortedByRecentChat() async {
    final usersSnapshot = await _firestore.collection('users').get();

    final otherUsers =
        usersSnapshot.docs.where((doc) => doc.id != currentUserId).toList();

    final futures = otherUsers.map(_getLastMessageAndUser).toList();

    final result = await Future.wait(futures);

    result.sort((a, b) {
      final aTime = a['lastTimestamp'] as Timestamp?;
      final bTime = b['lastTimestamp'] as Timestamp?;
      return (bTime?.compareTo(aTime ?? Timestamp(0, 0)) ?? 0);
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text('Chats', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUsersSortedByRecentChat(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final sortedUsers = snapshot.data!;

          return ListView.builder(
            itemCount: sortedUsers.length,
            itemBuilder: (context, index) {
              final userDoc = sortedUsers[index]['userDoc'] as DocumentSnapshot;
              final lastMessage = sortedUsers[index]['lastMessage'] as String;
              final userId = userDoc.id;
              final username = userDoc['username'] ?? 'Unknown';
              final imageUrl = userDoc['image_url'];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      imageUrl != null ? NetworkImage(imageUrl) : null,
                  child: imageUrl == null ? const Icon(Icons.person) : null,
                ),
                title: Text(username),
                subtitle:
                    lastMessage.isNotEmpty
                        ? Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                        : const Text(""),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (ctx) => Chats(
                            key: ValueKey(userId),
                            otherUserId: userId,
                            otherUserName: username,
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
