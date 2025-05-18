import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:grad_project/core/widgets/buildDrawer.dart';
import 'package:grad_project/core/models/fixturesCarouselSlider.dart';
import 'package:grad_project/screens/signinOptions/chooseFavTeam.dart';
import 'package:grad_project/core/providers/favoritesProvider.dart';
import 'package:grad_project/core/firestoreServices/fetchTeamData.dart';

class FavTeamsScreen extends ConsumerStatefulWidget {
  const FavTeamsScreen({super.key});

  @override
  ConsumerState<FavTeamsScreen> createState() => _FavTeamsScreenState();
}

class _FavTeamsScreenState extends ConsumerState<FavTeamsScreen> {
  Future<List<Map<String, dynamic>>> fetchFixtures(String teamName) async {
    try {
      // Fetch parent team document
      final teamSnapshot =
          await FirebaseFirestore.instance
              .collection('fixtures')
              .where('TeamName', isEqualTo: teamName)
              .get();

      if (teamSnapshot.docs.isEmpty) return [];

      final teamDoc = teamSnapshot.docs.first;
      final teamDocId = teamDoc.id;

      // Extract parent-level info
      final homeDisplay = teamDoc.data()['Display'] ?? 'HOM';
      final teamLogo = teamDoc.data()['TeamLogo'] ?? '';

      // Fetch fixtures subcollection
      final teamFixturesSnapshot =
          await FirebaseFirestore.instance
              .collection('fixtures')
              .doc(teamDocId)
              .collection('TeamFixtures')
              .get();

      // Process each fixture and attach parent info
      return teamFixturesSnapshot.docs.map((doc) {
        final data = doc.data();

        // Format the timestamp
        if (data['DateTime'] is Timestamp) {
          final formatter = DateFormat('d MMM yyyy • hh:mm a');
          data['DateTime'] = formatter.format(
            (data['DateTime'] as Timestamp).toDate(),
          );
        }

        // Add parent info to fixture
        data['Display'] = homeDisplay;
        data['TeamLogo'] = teamLogo;

        return data;
      }).toList();
    } catch (e) {
      print('Error in fetchFixtures: $e');
      return [];
    }
  }

  // Future<List<Map<String, dynamic>>> fetchResults(String teamName) async {
  //   final doc =
  //       await FirebaseFirestore.instance
  //           .collection('Results')
  //           .doc(teamName)
  //           .get();

  //   if (!doc.exists || !doc.data()!.containsKey('teamResults')) {
  //     return [];
  //   }

  //   final List<dynamic> rawResults = doc['teamResults'];

  //   return rawResults.map<Map<String, dynamic>>((result) {
  //     final data = Map<String, dynamic>.from(result);
  //     if (data['dateTime'] is Timestamp) {
  //       final timestamp = data['dateTime'] as Timestamp;
  //       final formatter = DateFormat('d MMM yyyy • hh:mm a');
  //       data['dateTime'] = formatter.format(timestamp.toDate());
  //     }
  //     return data;
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    final selectedTeams = ref.watch(favoriteTeamsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
            // --- Fixtures Tab ---
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
                            future: FixtureService.fetchFixtures(teamName),
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
                                      'No upcoming matches for $teamName',
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

            // --- Results Tab ---
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            //   child:
            //       selectedTeams.isEmpty
            //           ? Center(
            //             child: Text(
            //               'No favorite teams selected.',
            //               style: Theme.of(context).textTheme.bodyLarge,
            //             ),
            //           )
            //           : ListView.builder(
            //             itemCount: selectedTeams.length,
            //             itemBuilder: (context, index) {
            //               final teamName = selectedTeams.elementAt(index);

            //               return FutureBuilder<List<Map<String, dynamic>>>(
            //                 future: FixtureService.fetchResults(teamName),
            //                 builder: (context, snapshot) {
            //                   if (snapshot.connectionState ==
            //                       ConnectionState.waiting) {
            //                     return const Padding(
            //                       padding: EdgeInsets.symmetric(vertical: 12),
            //                       child: Center(
            //                         child: CircularProgressIndicator(),
            //                       ),
            //                     );
            //                   }

            //                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //                     return Padding(
            //                       padding: const EdgeInsets.symmetric(
            //                         vertical: 12,
            //                       ),
            //                       child: Center(
            //                         child: Text(
            //                           'No results available for $teamName',
            //                           style: Theme.of(
            //                             context,
            //                           ).textTheme.bodyMedium?.copyWith(
            //                             color:
            //                                 Theme.of(context).colorScheme.error,
            //                           ),
            //                         ),
            //                       ),
            //                     );
            //                   }

            //                   final results = snapshot.data!;
            //                   return Card(
            //                     margin: const EdgeInsets.symmetric(
            //                       vertical: 12,
            //                     ),
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(16),
            //                     ),
            //                     elevation: 4,
            //                     color:
            //                         Theme.of(
            //                           context,
            //                         ).colorScheme.primaryContainer,
            //                     child: Padding(
            //                       padding: const EdgeInsets.all(16),
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             teamName,
            //                             style: Theme.of(
            //                               context,
            //                             ).textTheme.titleMedium?.copyWith(
            //                               fontWeight: FontWeight.bold,
            //                               color:
            //                                   Theme.of(
            //                                     context,
            //                                   ).colorScheme.secondary,
            //                             ),
            //                           ),
            //                           const SizedBox(height: 8),
            //                           Text(
            //                             'Latest Results:',
            //                             style:
            //                                 Theme.of(
            //                                   context,
            //                                 ).textTheme.bodyMedium,
            //                           ),
            //                           const SizedBox(height: 12),
            //                           CarouselSlider(
            //                             options: CarouselOptions(
            //                               height: 160,
            //                               enlargeCenterPage: true,
            //                               enableInfiniteScroll: true,
            //                               autoPlay: true,
            //                               autoPlayInterval: const Duration(
            //                                 seconds: 3,
            //                               ),
            //                               viewportFraction: 0.9,
            //                             ),
            //                             items:
            //                                 results.map((result) {
            //                                   final opponent =
            //                                       result['opponent'] ??
            //                                       'Unknown';
            //                                   final dateTime =
            //                                       result['dateTime']
            //                                           ?.toString() ??
            //                                       'No date';
            //                                   final stadium =
            //                                       result['stadium'] ??
            //                                       'Unknown stadium';
            //                                   final status =
            //                                       result['status'] ?? 'N/A';
            //                                   final teamScore =
            //                                       result['teamScore']
            //                                           ?.toString() ??
            //                                       '-';
            //                                   final opponentScore =
            //                                       result['opponentScore']
            //                                           ?.toString() ??
            //                                       '-';

            //                                   return Container(
            //                                     margin:
            //                                         const EdgeInsets.symmetric(
            //                                           horizontal: 4,
            //                                         ),
            //                                     decoration: BoxDecoration(
            //                                       color:
            //                                           Theme.of(
            //                                             context,
            //                                           ).colorScheme.secondary,
            //                                       borderRadius:
            //                                           BorderRadius.circular(15),
            //                                       boxShadow: [
            //                                         BoxShadow(
            //                                           color: Colors.black
            //                                               .withOpacity(0.1),
            //                                           blurRadius: 4,
            //                                           offset: const Offset(
            //                                             0,
            //                                             2,
            //                                           ),
            //                                         ),
            //                                       ],
            //                                     ),
            //                                     child: ClipRRect(
            //                                       borderRadius:
            //                                           BorderRadius.circular(15),
            //                                       child: Padding(
            //                                         padding:
            //                                             const EdgeInsets.all(
            //                                               12,
            //                                             ),
            //                                         child: Column(
            //                                           crossAxisAlignment:
            //                                               CrossAxisAlignment
            //                                                   .start,
            //                                           mainAxisAlignment:
            //                                               MainAxisAlignment
            //                                                   .center,
            //                                           children: [
            //                                             Text(
            //                                               '$teamName $teamScore - $opponentScore $opponent',
            //                                               style:
            //                                                   const TextStyle(
            //                                                     color:
            //                                                         Colors
            //                                                             .white,
            //                                                     fontWeight:
            //                                                         FontWeight
            //                                                             .bold,
            //                                                   ),
            //                                             ),
            //                                             const SizedBox(
            //                                               height: 4,
            //                                             ),
            //                                             Text(
            //                                               'Date: $dateTime',
            //                                               style:
            //                                                   const TextStyle(
            //                                                     color:
            //                                                         Colors
            //                                                             .white,
            //                                                   ),
            //                                             ),
            //                                             Text(
            //                                               'Stadium: $stadium',
            //                                               style: const TextStyle(
            //                                                 color:
            //                                                     Colors.white70,
            //                                               ),
            //                                             ),
            //                                             Text(
            //                                               'Status: $status',
            //                                               style: const TextStyle(
            //                                                 color:
            //                                                     Colors.white70,
            //                                               ),
            //                                             ),
            //                                           ],
            //                                         ),
            //                                       ),
            //                                     ),
            //                                   );
            //                                 }).toList(),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   );
            //                 },
            //               );
            //             },
            //           ),
            // ),
          ],
        ),
      ),
    );
  }
}
