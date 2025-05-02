import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class JazeeraMatchItem extends StatefulWidget {
  final String teamName;
  const JazeeraMatchItem({super.key, required this.teamName});

  @override
  State<JazeeraMatchItem> createState() => _MatchItemState();
}

class _MatchItemState extends State<JazeeraMatchItem> {
  @override
  Widget build(BuildContext context) {
    return Link(
      target: LinkTarget.self,
      uri: Uri.parse(
        'https://www.365scores.com/ar/football/team/al-jazeera-8283',
      ),
      builder:
          (context, followLink) => InkWell(
            onTap: followLink,
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Thursday, 3rd April',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Jaz',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/images/AlJazeera.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '16:00',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/images/Salt.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sal',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
