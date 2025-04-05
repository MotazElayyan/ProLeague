import 'package:flutter/material.dart';

class TeamsRow extends StatefulWidget {
  final String imgAsset1;
  final String imgAsset2;
  const TeamsRow({super.key, required this.imgAsset1, required this.imgAsset2});

  @override
  State<TeamsRow> createState() => _TeamsRowState();
}

class _TeamsRowState extends State<TeamsRow> {
  bool isChecked1 = false;
  bool isChecked2 = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: Theme.of(context).colorScheme.secondary,
          value: isChecked1,
          onChanged: (value) {
            setState(() {
              isChecked1 = value!;
            });
          },
        ),
        SizedBox(width: 5),
        Image.asset(widget.imgAsset1, width: 120, height: 120),
        SizedBox(width: 25),
        Checkbox(
          activeColor: Theme.of(context).colorScheme.secondary,
          value: isChecked2,
          onChanged: (value) {
            setState(() {
              isChecked2 = value!;
            });
          },
        ),
        SizedBox(width: 5),
        Image.asset(widget.imgAsset2, width: 120, height: 120),
      ],
    );
  }
}