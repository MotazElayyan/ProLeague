import 'package:flutter/material.dart';
import 'package:grad_project/models/matchItem.dart';

class FavTeams extends StatefulWidget {
  const FavTeams({super.key});

  @override
  State<FavTeams> createState() => _FavTeamsState();
}

class _FavTeamsState extends State<FavTeams> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Pro', style: TextStyle(fontSize: 35)),
                Image.asset('assets/images/logo1.png', height: 35, width: 35),
                Text('League', style: TextStyle(fontSize: 35)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Fixtures',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                MatchItem(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
