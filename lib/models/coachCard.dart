import 'package:flutter/material.dart';

class CoachCard extends StatelessWidget {
  final Map<String, String> coach;

  const CoachCard(this.coach, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (coach['picture'] != null && coach['picture']!.isNotEmpty)
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(coach['picture']!),
            ),
          const SizedBox(height: 10),
          Text(
            coach['team']!,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            coach['name']!.isNotEmpty ? coach['name']! : 'TBA',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
