import 'package:flutter/material.dart';

import 'package:grad_project/models/elevatedButton.dart';
import 'package:grad_project/screens/signinOptions/loginPage.dart';
import 'package:grad_project/screens/signinOptions/signupPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: Align(
                alignment: AlignmentDirectional(0, -1.98),
                child: Icon(
                  Icons.sports_soccer,
                  color: Color(0xFF363272),
                  size: 500,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo1.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
                Text('Welcome', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                Text(
                  'Help us tailor your experience by answering a few quick and easy questions',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 70),
                CustomElevatedButton(
                  title: 'Get Started',
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (ctx) => SignupPage()));
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Already have an account?',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5),
                CustomElevatedButton(
                  title: 'Log In',
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (ctx) => LoginPage()));
                  },
                ),
              ],
            ),
            Opacity(
              opacity: 0.3,
              child: Align(
                alignment: AlignmentDirectional(10, 3),
                child: Icon(
                  Icons.sports_soccer,
                  color: Color(0xFF363272),
                  size: 500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
