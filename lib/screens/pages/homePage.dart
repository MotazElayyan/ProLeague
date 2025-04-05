import 'package:flutter/material.dart';
import 'package:grad_project/screens/pages/landingPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (ctx) => LandingPage()));
          },
          child: Image.asset(
            'assets/images/logo1.png',
            height: 301,
            width: 229,
          ),
        ),
      ),
    );
  }
}
