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

  Future<String> _getLastMessage(String currentUserId, String otherUserId) async {
    final participants = [currentUserId, otherUserId]..sort();

    final query = await _firestore
        .collection('messages')
        .where('participants', isEqualTo: participants)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first['text'] ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('Not signed in'));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text('Chats', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs
              .where((u) => u.id != currentUser.uid)
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user.id;
              final username = user['username'] ?? 'Unknown';
              final imageUrl = user['image_url'];

              return FutureBuilder<String>(
                future: _getLastMessage(currentUser.uid, userId),
                builder: (context, snapshot) {
                  final lastMessage = snapshot.data ?? '';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          imageUrl != null ? NetworkImage(imageUrl) : null,
                      child:
                          imageUrl == null ? const Icon(Icons.person) : null,
                    ),
                    title: Text(username),
                    subtitle: lastMessage.isNotEmpty
                        ? Text(
                            lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          )
                        : const Text(""),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => Chats(
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
          );
        },
      ),
    );
  }
}
