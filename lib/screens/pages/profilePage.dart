import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/widgets/imageInput.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool firstSwitchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageInput(),
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
                'General Settings',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.light),
              Text(
                'Mode (Dark/Light)',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 17),
              ),
              Icon(Icons.sunny),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.key),
              Text(
                'Change Password',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 17),
              ),
              Icon(Icons.arrow_forward_ios),
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
              Icon(Icons.phone_iphone),
              Text(
                '    About App    ',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 17),
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.privacy_tip_rounded),
              Text(
                '  Privacy Policy  ',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 17),
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.share),
              Text(
                '  Share This App  ',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 17),
              ),
              Icon(Icons.arrow_forward_ios),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.exit_to_app),
              Text(
                '     Log out     ',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 17),
              ),
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
