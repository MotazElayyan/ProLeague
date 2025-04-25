import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:grad_project/models/elevatedButton.dart';
import 'package:grad_project/models/customTeamsRow.dart';
import 'package:grad_project/widgets/tabs.dart';
import 'package:grad_project/providers/favoritesProvider.dart';

class ChooseFavTeam extends ConsumerStatefulWidget {
  const ChooseFavTeam({super.key});

  @override
  ConsumerState<ChooseFavTeam> createState() => _ChooseFavTeamState();
}

class _ChooseFavTeamState extends ConsumerState<ChooseFavTeam> {
  void _start() {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Tabs()));
  }

  Set<String> selectedTeams = {};

  void _toggleSelection(String team) {
    ref.read(favoriteTeamsProvider.notifier).toggleTeam(team);
    setState(() {
      if (selectedTeams.contains(team)) {
        selectedTeams.remove(team);
      } else {
        selectedTeams.add(team);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Choose Your Favorite Team'),
      ),
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: Align(
                alignment: AlignmentDirectional(0, -1.98),
                child: Icon(
                  Icons.sports_soccer,
                  color: Color(0xFF363272),
                  size: 500,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomElevatedButton(title: 'Skip >', onPressed: _start),
                  TeamsRow(
                    imgAsset1: 'assets/images/AlJazeera.png',
                    imgAsset2: 'assets/images/ShababJ.png',
                    teamName1: 'Al Jazeera',
                    teamName2: 'Shabab Al Ordon',
                    selectedTeams: selectedTeams,
                    toggleSelection: _toggleSelection,
                  ),
                  SizedBox(height: 10),
                  TeamsRow(
                    imgAsset1: 'assets/images/Faisaly.png',
                    imgAsset2: 'assets/images/Wehdat.png',
                    teamName1: 'Al Faisaly',
                    teamName2: 'Al Wehdat',
                    selectedTeams: selectedTeams,
                    toggleSelection: _toggleSelection,
                  ),
                  SizedBox(height: 10),
                  TeamsRow(
                    imgAsset1: 'assets/images/Hussain.gif',
                    imgAsset2: 'assets/images/Ramtha.png',
                    teamName1: 'Al Hussein',
                    teamName2: 'Al Ramtha',
                    selectedTeams: selectedTeams,
                    toggleSelection: _toggleSelection,
                  ),
                  SizedBox(height: 10),
                  TeamsRow(
                    imgAsset1: 'assets/images/Moghayer.png',
                    imgAsset2: 'assets/images/maan.png',
                    teamName1: 'Moghayer Al Sarhan',
                    teamName2: 'Maan',
                    selectedTeams: selectedTeams,
                    toggleSelection: _toggleSelection,
                  ),
                  SizedBox(height: 10),
                  TeamsRow(
                    imgAsset1: 'assets/images/Salt.png',
                    imgAsset2: 'assets/images/ShababA.png',
                    teamName1: 'Al Salt',
                    teamName2: 'Shabab Al Aqaba',
                    selectedTeams: selectedTeams,
                    toggleSelection: _toggleSelection,
                  ),
                  SizedBox(height: 10),
                  TeamsRow(
                    imgAsset1: 'assets/images/Sareeh.png',
                    imgAsset2: 'assets/images/Ahli.jpg',
                    teamName1: 'Al Sareeh',
                    teamName2: 'Al Ahli',
                    selectedTeams: selectedTeams,
                    toggleSelection: _toggleSelection,
                  ),
                  SizedBox(height: 10),
                  CustomElevatedButton(
                    title: 'Continue >',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (ctx) => Tabs(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
