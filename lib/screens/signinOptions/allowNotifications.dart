import 'package:flutter/material.dart';
import 'package:grad_project/models/elevatedButton.dart';

import 'package:grad_project/screens/signinOptions/chooseFavTeam.dart';

class AllowNotifications extends StatefulWidget {
  const AllowNotifications({super.key});

  @override
  State<AllowNotifications> createState() => _AllowNotificationsState();
}

class _AllowNotificationsState extends State<AllowNotifications> {
  bool _isProcessing = false;

  Future<void> _handleAllowNotifications() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const ChooseFavTeam(),
        ),
        (route) => false,
      );
    }
  }

  void _handleDenyNotifications() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const ChooseFavTeam(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text('Notifications', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.notifications,
                size: 140,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 40),
              Text(
                'Would You Like To Recieve\nNotifications From This App?',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 25),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isProcessing
                      ? const SizedBox(
                          width: 200,
                          height: 48,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : CustomElevatedButton(
                          title: 'Yes, Send Notifications',
                          onPressed: _handleAllowNotifications,
                        ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: _isProcessing ? null : _handleDenyNotifications,
                    child: Text(
                      'No, Thanks',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
