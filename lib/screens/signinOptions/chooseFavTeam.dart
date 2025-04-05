import 'package:flutter/material.dart';
import 'package:grad_project/models/elevatedButton.dart';
import 'package:grad_project/models/customTeamsRow.dart';
import 'package:grad_project/widgets/tabs.dart';

class ChooseFavTeam extends StatefulWidget {
  const ChooseFavTeam({super.key});

  @override
  State<ChooseFavTeam> createState() => _ChooseFavTeamState();
}

class _ChooseFavTeamState extends State<ChooseFavTeam> {
  void _start () {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Tabs()));
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
                  CustomElevatedButton(
                    title: 'Skip >',
                    onPressed: _start
                  ),
                  TeamsRow(
                    imgAsset1: 'assets/images/AlJazeera.png',
                    imgAsset2: 'assets/images/ShababJ.png',
                  ),
                  SizedBox(height: 10),
                  TeamsRow(
                    imgAsset1: 'assets/images/Faisaly.png',
                    imgAsset2: 'assets/images/Wehdat.png',
                  ),
                  SizedBox(height: 10),
                  TeamsRow(
                    imgAsset1: 'assets/images/Hussain.gif',
                    imgAsset2: 'assets/images/Ramtha.png',
                  ),
                  SizedBox(height: 10),
                  TeamsRow(
                    imgAsset1: 'assets/images/Moghayer.png',
                    imgAsset2: 'assets/images/maan.png',
                  ),
                  SizedBox(height: 10),
                  TeamsRow(
                    imgAsset1: 'assets/images/Salt.png',
                    imgAsset2: 'assets/images/ShababA.png',
                  ),
                  SizedBox(height: 10),
                  TeamsRow(
                    imgAsset1: 'assets/images/Sareeh.png',
                    imgAsset2: 'assets/images/Ahli.jpg',
                  ),
                  SizedBox(height: 10),
                  CustomElevatedButton(
                    title: 'Continue >',
                    onPressed: _start
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
