import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  final Color color;
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(icon),
      label: Text(text),
      backgroundColor: color,
      onPressed: onPressed,
    );
  }
}
