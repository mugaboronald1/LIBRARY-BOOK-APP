import 'package:flutter/material.dart';

class Multilinetextformfield extends StatelessWidget {
  final String hintText;

  final TextEditingController controller;
  const Multilinetextformfield({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 5,
      controller: controller,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        filled: true,
        hintText: hintText,
      ),
    );
  }
}
