import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grad_project/models/statCard.dart';
import 'package:grad_project/screens/tabs/awardsPage.dart';
import 'package:grad_project/teamsData/playersGoals.dart';
import 'package:grad_project/teamsData/teamsGoals.dart';
import 'package:grad_project/widgets/buildDrawer.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Map<String, dynamic>? topPlayer;
  Map<String, dynamic>? topTeam;

  @override
  void initState() {
    super.initState();
    fetchTopStats();
  }

  Future<void> fetchTopStats() async {
    final teamsSnapshot =
        await FirebaseFirestore.instance.collection('teams').get();

    final List<Map<String, dynamic>> players = [];
    final List<Map<String, dynamic>> teams = [];

    for (var teamDoc in teamsSnapshot.docs) {
      final teamData = teamDoc.data();
      final teamLogo = teamData['TeamLogo'] ?? '';

      if (teamData.containsKey('TeamGoals') && teamData['TeamGoals'] != null) {
        teams.add({
          'name': teamData['TeamName'] ?? '',
          'logo': teamLogo,
          'goals': int.tryParse(teamData['TeamGoals'].toString()) ?? 0,
        });
      }

      final membersSnapshot =
          await FirebaseFirestore.instance
              .collection('teams')
              .doc(teamDoc.id)
              .collection('Members')
              .get();

      for (var memberDoc in membersSnapshot.docs) {
        final memberData = memberDoc.data();
        if (memberData.containsKey('Goals') && memberData['Goals'] != null) {
          players.add({
            'name': memberData['Name'] ?? '',
            'goals': int.tryParse(memberData['Goals'].toString()) ?? 0,
            'picture': memberData['picture'] ?? '',
          });
        }
      }
    }

    players.removeWhere((p) => p['goals'] == 0);
    teams.removeWhere((t) => t['goals'] == 0);

    players.sort((a, b) => b['goals'].compareTo(a['goals']));
    teams.sort((a, b) => b['goals'].compareTo(a['goals']));

    setState(() {
      topPlayer = players.isNotEmpty ? players.first : null;
      topTeam = teams.isNotEmpty ? teams.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text('Season', style: Theme.of(context).textTheme.titleLarge),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Colors.grey,
            tabs: const [Tab(text: 'Statistics'), Tab(text: 'Awards')],
          ),
        ),
        drawer: BuildDrawer(),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2024/2025 Top Stats',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      StatCard(
                        title: 'Goals',
                        value:
                            topPlayer != null
                                ? topPlayer!['goals'].toString()
                                : '0',
                        imgUrl:
                            topPlayer != null
                                ? topPlayer!['picture']
                                : 'assets/images/player.png',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (ctx) => PlayersGoals()),
                          );
                        },
                      ),
                      StatCard(
                        title: 'Most Assists',
                        value: '11',
                        imgUrl: 'assets/images/player.png',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Team Goals',
                          value:
                              topTeam != null
                                  ? topTeam!['goals'].toString()
                                  : '0',
                          imgUrl:
                              topTeam != null
                                  ? topTeam!['logo']
                                  : 'assets/images/player.png',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (ctx) => TeamsGoals()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          title: 'Most Passes',
                          value: '7,885',
                          imgUrl: 'assets/images/player.png',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AwardsTab(),
          ],
        ),
      ),
    );
  }
}
