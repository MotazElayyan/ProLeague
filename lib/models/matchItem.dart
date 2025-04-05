import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class MatchItem extends StatefulWidget {
  const MatchItem({super.key});

  @override
  State<MatchItem> createState() => _MatchItemState();
}

class _MatchItemState extends State<MatchItem> {
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
                              'Jaz',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              'assets/images/AlJazeera.png',
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
                              'assets/images/Salt.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 5),
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
        ),
        Link(
          target: LinkTarget.self,
          uri: Uri.parse(
            'https://www.365scores.com/ar/football/match/pro-league-565/al-hussein-al-jazeera-8283-8285-565#id=4388775',
          ),
          builder:
              (context, followLink) => InkWell(
                child: Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Tuesday, 8th April',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            Text(
                              'Jaz',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              'assets/images/AlJazeera.png',
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
                                '17:00',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              'assets/images/Hussain.gif',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Hus',
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Sunday, 13th April',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            Text(
                              'Jaz',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              'assets/images/AlJazeera.png',
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
                                '19:45',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              'assets/images/Faisaly.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Fai',
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
