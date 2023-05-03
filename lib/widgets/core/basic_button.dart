import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final String text;

  const BasicButton({super.key, required this.text, required this.background, required this.foreground, required this.onPressed});

  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(background),
        foregroundColor: MaterialStateProperty.all<Color>(foreground),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      child: Text(text),
    );
  }
}
