import 'package:flutter/material.dart';
import 'package:pet_sitting/styles.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(icon),
      label: Text(text),
      backgroundColor: MAIN_GREEN,
      onPressed: onPressed,
    );
  }
}
