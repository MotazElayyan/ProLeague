import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:grad_project/providers/favoritesProvider.dart';
import 'package:grad_project/teams/faisalyMatchItem.dart';
import 'package:grad_project/teams/ahliMatchItem.dart';
import 'package:grad_project/teams/aqabamatchItem.dart';
import 'package:grad_project/teams/hussienMatchItem.dart';
import 'package:grad_project/teams/jazeeraMatchItem.dart';
import 'package:grad_project/teams/maanMatchItem.dart';
import 'package:grad_project/teams/ramthaMatchItem.dart';
import 'package:grad_project/teams/saltMatchItem.dart';
import 'package:grad_project/teams/sareehMatchItem.dart';
import 'package:grad_project/teams/sarhanMatchItem.dart';
import 'package:grad_project/teams/shababjMatchItem.dart';
import 'package:grad_project/teams/wehdatMatchItem.dart';
import 'package:grad_project/widgets/buildDrawer.dart';
import 'package:grad_project/screens/signinOptions/chooseFavTeam.dart';

final Map<String, List<Widget>> teamMatchWidgets = {
  'Al Jazeera': [JazeeraMatchItem(teamName: 'Al Jazeera')],
  'Al Wehdat': [WehdatMatchItem(teamName: 'Al Wehdat')],
  'Al Faisaly': [FaisalyMatchItem(teamName: 'Al Faisaly')],
  'Al Ramtha': [RamthaMatchItem(teamName: 'Al Ramtha')],
  'Al Ahli': [AhliMatchItem(teamName: 'Al Ahli')],
  'Al Salt': [SaltMatchItem(teamName: 'Al Salt')],
  'Shabab Al Aqaba': [AqabaMatchItem(teamName: 'Shabab Al Aqaba')],
  'Al Hussein': [HusseinMatchItem(teamName: 'Al Hussein')],
  'Maan': [MaanMatchItem(teamName: 'Maan')],
  'Al Sareeh': [SareehMatchItem(teamName: 'Al Sareeh')],
  'Moghayer Al Sarhan': [SarhanMatchItem(teamName: 'Moghayer Al Sarhan')],
  'Shabab Al Ordon': [ShababMatchItem(teamName: 'Shabab Al Ordon')],
};

class FavTeamsScreen extends ConsumerStatefulWidget {
  const FavTeamsScreen({super.key});

  @override
  ConsumerState<FavTeamsScreen> createState() => _FavTeamsScreenState();
}

class _FavTeamsScreenState extends ConsumerState<FavTeamsScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedTeams = ref.watch(favoriteTeamsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pro ', style: Theme.of(context).textTheme.titleLarge),
            Image.asset('assets/images/logo1.png', width: 40, height: 40),
            Text(' League', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ChooseFavTeam()),
              );
            },
          ),
        ],
      ),
      drawer: BuildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: selectedTeams.length,
                itemBuilder: (context, index) {
                  final teamName = selectedTeams.elementAt(index);
                  final matchWidgets = teamMatchWidgets[teamName];

                  if (matchWidgets == null || matchWidgets.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'No matches available for $teamName',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    );
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teamName,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Fixtures',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 150,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 2),
                              viewportFraction: 0.9,
                            ),
                            items:
                                matchWidgets.map((match) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.surfaceContainer,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: match,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
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
