import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (docSnapshot.exists) {
        setState(() {
          _imageUrl = docSnapshot.data()?['image_url'];
        });
      }
    } catch (error) {
      print('Error loading user profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Profile'),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _imageUrl == null
                ? const CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50),
                )
                : CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(_imageUrl!),
                ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 37,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'General Settings',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.light),
                Text(
                  'Mode (Dark/Light)',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontSize: 17),
                ),
                const Icon(Icons.sunny),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.key),
                Text(
                  'Change Password',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontSize: 17),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: 37,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Information',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.phone_iphone),
                Text(
                  'About App',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontSize: 17),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.privacy_tip_rounded),
                Text(
                  'Privacy Policy',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontSize: 17),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.share),
                Text(
                  'Share This App',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontSize: 17),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: 37,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Account Settings',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     const Icon(Icons.exit_to_app),
            //     Text(
            //       'Log out',
            //       style: Theme.of(
            //         context,
            //       ).textTheme.bodyLarge!.copyWith(fontSize: 17),
            //     ),
            //     IconButton(
            //       onPressed: () {
            //         FirebaseAuth.instance.signOut();
            //       },
            //       icon: const Icon(Icons.arrow_forward_ios),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
