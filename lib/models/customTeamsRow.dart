import 'package:flutter/material.dart';

class TeamsRow extends StatefulWidget {
  final String imgAsset1;
  final String imgAsset2;
  final String teamName1;
  final String teamName2;
  final Set<String> selectedTeams;
  final void Function(String teamName) toggleSelection;

  const TeamsRow({
    super.key,
    required this.imgAsset1,
    required this.imgAsset2,
    required this.teamName1,
    required this.teamName2,
    required this.selectedTeams,
    required this.toggleSelection,
  });

  @override
  State<TeamsRow> createState() => _TeamsRowState();
}

class _TeamsRowState extends State<TeamsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          activeColor: Theme.of(context).colorScheme.secondary,
          value: widget.selectedTeams.contains(widget.teamName1),
          onChanged: (value) {
            widget.toggleSelection(widget.teamName1);
          },
        ),
        const SizedBox(width: 5),
        Image.asset(widget.imgAsset1, width: 120, height: 120),
        const SizedBox(width: 25),
        Checkbox(
          activeColor: Theme.of(context).colorScheme.secondary,
          value: widget.selectedTeams.contains(widget.teamName2),
          onChanged: (value) {
            widget.toggleSelection(widget.teamName2);
          },
        ),
        const SizedBox(width: 5),
        Image.asset(widget.imgAsset2, width: 120, height: 120),
      ],
    );
  }
}
