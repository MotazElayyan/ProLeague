import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostItem extends StatefulWidget {
  final Map<String, dynamic> postData;

  const PostItem({super.key, required this.postData});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late final String currentUserId;
  bool hasReported = false;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _checkIfReported();
  }

  void _toggleLike(String postId, bool isLiked) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    await postRef.update({
      'likes':
          isLiked
              ? FieldValue.arrayRemove([currentUserId])
              : FieldValue.arrayUnion([currentUserId]),
    });
  }

  void _showCommentDialog(String postId) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            title: Text(
              'Add Comment',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type your comment...',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (controller.text.trim().isNotEmpty) {
                    final userDoc =
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUserId)
                            .get();

                    final userData = userDoc.data();

                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('comments')
                        .add({
                          'text': controller.text.trim(),
                          'userId': currentUserId,
                          'timestamp': Timestamp.now(),
                          'username': userData?['username'] ?? 'User',
                          'userImage': userData?['image_url'] ?? '',
                        });

                    Navigator.of(ctx).pop();
                  }
                },
                child: Text(
                  'Post',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
    );
  }

  void _shareToChat(BuildContext context) async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => ListView(
            children:
                usersSnapshot.docs.where((doc) => doc.id != currentUserId).map((
                  user,
                ) {
                  final uid = user.id;
                  final username = user['username'] ?? 'User';

                  return ListTile(
                    title: Text(username),
                    onTap: () async {
                      final chatId = _getChatId(currentUserId, uid);
                      await FirebaseFirestore.instance
                          .collection('messages')
                          .doc(chatId)
                          .collection('chat')
                          .add({
                            'postShared': true,
                            'postText': widget.postData['text'] ?? '',
                            'postImage': widget.postData['imageUrl'] ?? '',
                            'createdAt': Timestamp.now(),
                            'userId': currentUserId,
                            'username':
                                FirebaseAuth
                                    .instance
                                    .currentUser
                                    ?.displayName ??
                                'Me',
                            'profileImage':
                                FirebaseAuth.instance.currentUser?.photoURL ??
                                '',
                          });

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post shared to chat')),
                      );
                    },
                  );
                }).toList(),
          ),
    );
  }

  void _checkIfReported() async {
    final reportDoc =
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postData['id'])
            .collection('reports')
            .doc(currentUserId)
            .get();

    if (mounted) {
      setState(() {
        hasReported = reportDoc.exists;
      });
    }
  }

  String _getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final postId = widget.postData['id'];
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    return StreamBuilder<DocumentSnapshot>(
      stream: postRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final rawData = snapshot.data!.data();
        if (rawData == null) return const SizedBox();

        final postData = rawData as Map<String, dynamic>;
        final likes = postData['likes'] ?? [];
        final isLiked = likes.contains(currentUserId);
        final username = postData['username'] ?? 'Unknown';
        final userImage = postData['userImage'] ?? '';
        final text = postData['text'] ?? '';
        final postImage = postData['imageUrl'];
        final timestamp = postData['timestamp']?.toDate();

        return Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userImage),
                      radius: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      username,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    if (timestamp != null)
                      Text(
                        '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Post text
                if (text.isNotEmpty)
                  Text(text, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),

                // Image
                if (postImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      postImage,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 8),

                // Like / Comment / Share Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ❤️ Like
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => _toggleLike(postId, isLiked),
                        ),
                        Text('${likes.length}'),
                      ],
                    ),

                    // 💬 Comment
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () => _showCommentDialog(postId),
                    ),

                    // 📤 Share
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _shareToChat(context),
                    ),

                    // 🗑️ Delete or 🚩 Report
                    if (postData['uid'] == currentUserId)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                    'Are you sure you want to delete this post?',
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed:
                                          () => Navigator.of(ctx).pop(false),
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed:
                                          () => Navigator.of(ctx).pop(true),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            await FirebaseFirestore.instance
                                .collection('posts')
                                .doc(postId)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Post deleted')),
                            );
                          }
                        },
                      )
                    else
                      IconButton(
                        icon: Icon(
                          hasReported ? Icons.flag : Icons.flag_outlined,
                          color: hasReported ? Colors.orange : null,
                        ),
                        onPressed: () async {
                          final reportRef = FirebaseFirestore.instance
                              .collection('posts')
                              .doc(postId)
                              .collection('reports')
                              .doc(currentUserId);

                          if (hasReported) {
                            // REMOVE report
                            await reportRef.delete();
                            if (mounted) {
                              setState(() {
                                hasReported = false;
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Report removed')),
                            );
                          } else {
                            // ADD report
                            await reportRef.set({
                              'reportedAt': Timestamp.now(),
                              'userId': currentUserId,
                            });
                            if (mounted) {
                              setState(() {
                                hasReported = true;
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Post reported. Thank you!'),
                              ),
                            );
                          }
                        },
                      ),
                  ],
                ),

                // Comments List
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .collection('comments')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    final comments = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment =
                            comments[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(
                                  comment['userImage'] ?? '',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment['username'] ?? 'User',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(comment['text'] ?? ''),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
