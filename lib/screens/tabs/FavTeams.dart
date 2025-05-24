import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:grad_project/core/widgets/buildDrawer.dart';
import 'package:grad_project/core/models/fixturesCarouselSlider.dart';
import 'package:grad_project/core/models/resultsCarouselSlider.dart';
import 'package:grad_project/screens/signinOptions/chooseFavTeam.dart';
import 'package:grad_project/core/providers/favoritesProvider.dart';
import 'package:grad_project/core/firestoreServices/fetchTeamData.dart';

class FavTeamsScreen extends ConsumerStatefulWidget {
  const FavTeamsScreen({super.key});

  @override
  ConsumerState<FavTeamsScreen> createState() => _FavTeamsScreenState();
}

class _FavTeamsScreenState extends ConsumerState<FavTeamsScreen> {
  bool _isLoading = false;

  Future<List<Map<String, dynamic>>> fetchFixtures(String teamName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final teamSnapshot =
          await FirebaseFirestore.instance
              .collection('fixtures')
              .where('TeamName', isEqualTo: teamName)
              .get();

      if (teamSnapshot.docs.isEmpty) return [];

      final teamDoc = teamSnapshot.docs.first;
      final teamDocId = teamDoc.id;

      final homeDisplay = teamDoc.data()['Display'] ?? 'HOM';
      final teamLogo = teamDoc.data()['TeamLogo'] ?? '';

      final teamFixturesSnapshot =
          await FirebaseFirestore.instance
              .collection('fixtures')
              .doc(teamDocId)
              .collection('TeamFixtures')
              .get();

      return teamFixturesSnapshot.docs.map((doc) {
        final data = doc.data();

        if (data['DateTime'] is Timestamp) {
          final formatter = DateFormat('d MMM yyyy • hh:mm a');
          data['DateTime'] = formatter.format(
            (data['DateTime'] as Timestamp).toDate(),
          );
        }

        data['Display'] = homeDisplay;
        data['TeamLogo'] = teamLogo;

        setState(() {
          _isLoading = false;
        });

        return data;
      }).toList();
    } catch (e) {
      print('Error in fetchFixtures: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTeams = ref.watch(favoriteTeamsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Pro', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(width: 4),
              Image.asset('assets/images/logo1.png', width: 35, height: 35),
              const SizedBox(width: 4),
              Text('League', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.secondary,
                size: 28,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ChooseFavTeam(),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Colors.grey,
            tabs: const [Tab(text: 'Fixtures'), Tab(text: 'Results')],
          ),
        ),
        drawer: BuildDrawer(),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            // Fixtures Tab
            _isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child:
                      selectedTeams.isEmpty
                          ? Center(
                            child: Text(
                              'No favorite teams selected.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )
                          : ListView.builder(
                            itemCount: selectedTeams.length,
                            itemBuilder: (context, index) {
                              final teamName = selectedTeams.elementAt(index);

                              return FutureBuilder<List<Map<String, dynamic>>>(
                                future: FixtureService.fetchFixtures(teamName),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'No upcoming matches for $teamName',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  final fixtures = snapshot.data!;
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            teamName,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          FixturesCarouselSlider(
                                            fixtures: fixtures,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child:
                  selectedTeams.isEmpty
                      ? Center(
                        child: Text(
                          'No favorite teams selected.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                      : ListView.builder(
                        itemCount: selectedTeams.length,
                        itemBuilder: (context, index) {
                          final teamName = selectedTeams.elementAt(index);
                          return FutureBuilder<List<Map<String, dynamic>>>(
                            future: FixtureService.fetchResults(teamName),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'No results available for $teamName',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final results = snapshot.data!;
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        teamName,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ResultsCarouselSlider(results: results),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
