import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final Map<String, Widget> teamMatchWidgets = {
  'Al Jazeera': JazeeraMatchItem(teamName: 'Al Jazeera'),
  'Al Wehdat': WehdatMatchItem(teamName: 'Al Wehdat'),
  'Al Faisaly': FaisalyMatchItem(teamName: 'Al Faisaly'),
  'Al Ramtha': RamthaMatchItem(teamName: 'Al Ramtha'),
  'Al Ahli': AhliMatchItem(teamName: 'Al Ahli'),
  'Al Salt': SaltMatchItem(teamName: 'Al Salt'),
  'Shabab AL Aqaba': AqabaMatchItem(teamName: 'Shabab AL Aqaba'),
  'Al Hussein': HusseinMatchItem(teamName: 'Al Hussein'),
  'Maan': MaanMatchItem(teamName: 'Maan'),
  'Al Sareeh': SareehMatchItem(teamName: 'Al Sareeh'),
  'Moghayer AL Sarhan': SarhanMatchItem(teamName: 'Moghayer AL Sarhan'),
  'Shabab Al Ordon': ShababMatchItem(teamName: 'Shabab Al Ordon'),
};

class FavTeamsScreen extends ConsumerStatefulWidget {
  final List<String> selectedTeams;
  const FavTeamsScreen({super.key, required this.selectedTeams});

  @override
  ConsumerState<FavTeamsScreen> createState() => _FavTeamsScreenState();
}

class _FavTeamsScreenState extends ConsumerState<FavTeamsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Pro', style: Theme.of(context).textTheme.titleLarge),
                  Image.asset('assets/images/logo1.png', width: 50, height: 50,),
                  Text('League', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.selectedTeams.length,
                  itemBuilder: (context, index) {
                    final teamName = widget.selectedTeams[index];
                    final matchWidget = teamMatchWidgets[teamName];
                    if (matchWidget == null) {
                      return Text('No match data for $teamName');
                    }
                    return matchWidget;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}