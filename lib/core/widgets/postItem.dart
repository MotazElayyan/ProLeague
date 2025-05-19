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
  late bool isLiked;
  late List likes;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    likes = widget.postData['likes'] ?? [];
    isLiked = likes.contains(currentUserId);
  }

  void _toggleLike() async {
    final postId = widget.postData['id'];
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    setState(() {
      isLiked = !isLiked;
      isLiked ? likes.add(currentUserId) : likes.remove(currentUserId);
    });

    await postRef.update({
      'likes':
          isLiked
              ? FieldValue.arrayUnion([currentUserId])
              : FieldValue.arrayRemove([currentUserId]),
    });
  }

  void _showCommentDialog() {
    final controller = TextEditingController();
    final postId = widget.postData['id'];

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
                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('comments')
                        .add({
                          'text': controller.text.trim(),
                          'userId': currentUserId,
                          'timestamp': Timestamp.now(),
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

  String _getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final username = widget.postData['username'] ?? 'Unknown';
    final userImage = widget.postData['userImage'] ?? '';
    final text = widget.postData['text'] ?? '';
    final postImage = widget.postData['imageUrl'];
    final timestamp = widget.postData['timestamp']?.toDate();

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                  radius: 22,
                ),
                const SizedBox(width: 10),
                Text(username, style: Theme.of(context).textTheme.bodyLarge),
                const Spacer(),
                if (timestamp != null)
                  Text(
                    '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (text.isNotEmpty)
              Text(text, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: _toggleLike,
                    ),
                    Text('${likes.length}'),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: _showCommentDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _shareToChat(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
