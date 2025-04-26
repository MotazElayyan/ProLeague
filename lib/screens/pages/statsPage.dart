import 'package:flutter/material.dart';

import 'package:grad_project/models/statCard.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2024/2025 Top Stats',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildStatCard('Goals', '7', 'assets/images/player.png'),
                buildStatCard('Most Assists', '11', 'assets/images/player.png'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildStatCard('Goals', '25', 'assets/images/player.png'),
                buildStatCard('Most Passes', '7,885', 'assets/images/player.png'),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
