import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:grad_project/screens/pages/allusersPage.dart';
import 'package:grad_project/core/widgets/buildDrawer.dart';
import 'package:grad_project/screens/pages/createPostPage.dart';
import 'package:grad_project/core/widgets/postItem.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text('Community', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const CreatePostPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.chat_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => const Users()));
            },
          ),
        ],
      ),
      drawer: BuildDrawer(),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('posts')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data?.docs ?? [];

          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet!'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final postData = posts[index].data();
              return PostItem(postData: postData);
            },
          );
        },
      ),
    );
  }
}
