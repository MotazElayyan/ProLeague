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
                BuildStatCard(
                  title: 'Goals',
                  value: '7',
                  imgUrl: 'assets/images/player.png',
                ),
                BuildStatCard(
                  title: 'Most Assists',
                  value: '11',
                  imgUrl: 'assets/images/player.png',
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BuildStatCard(
                  title: 'Goals',
                  value: '25',
                  imgUrl: 'assets/images/player.png',
                ),
                BuildStatCard(
                  title: 'Most Passes',
                  value: '7,885',
                  imgUrl: 'assets/images/player.png',
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
