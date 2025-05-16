import 'package:flutter/material.dart';

import 'package:grad_project/screens/pages/playerAwardsPage.dart';
import 'package:grad_project/screens/pages/teamAwardsScreen.dart';
import 'package:grad_project/models/awardButton.dart';

class AwardsTab extends StatelessWidget {
  const AwardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Awards:', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        AwardButton(
          imagePath: 'assets/images/soccerplayer.png',
          label: 'Player Awards',
          destinationPage: const PlayerAwardsScreen(),
        ),
        const SizedBox(height: 20),
        AwardButton(
          imagePath: 'assets/images/soccerTeam.png',
          label: 'Team Awards',
          destinationPage: const TeamAwardsScreen(),
        ),
      ],
    );
  }
}


