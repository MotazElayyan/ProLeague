import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class SaltMatchItem extends StatefulWidget {
  final String teamName;
  const SaltMatchItem({super.key, required this.teamName});

  @override
  State<SaltMatchItem> createState() => _MatchItemState();
}

class _MatchItemState extends State<SaltMatchItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Link(
          target: LinkTarget.self,
          uri: Uri.parse(
            'https://www.365scores.com/ar/football/team/al-jazeera-8283',
          ),
          builder:
              (context, followLink) => InkWell(
                child: Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Thursday, 3rd April',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            Text(
                              'Sal',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              'assets/images/Salt.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 5),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                              ),
                              child: Text(
                                '16:00',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              'assets/images/Ramtha.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Ram',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ],
    );
  }
}
