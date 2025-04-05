import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    super.key,
    required this.hintText,
    required this.myController,
    this.icon,
  });

  final String hintText;
  final TextEditingController myController;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.primaryContainer,
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        prefixIcon: icon,
      ),
    );
  }
}
