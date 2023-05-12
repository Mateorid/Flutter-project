import 'package:flutter/material.dart';
import 'package:pet_sitting/styles.dart';

class UserInfoField extends StatelessWidget {
  final IconData icon;
  final String text;
  final double lPadding;

  const UserInfoField({
    super.key,
    required this.icon,
    required this.text,
    this.lPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: lPadding),
        Icon(
          icon,
          size: 50,
          color: MAIN_GREEN,
        ),
        const SizedBox(width: 30),
        Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            // color: DARK_GREEN,
          ),
        ),
      ],
    );
  }
}
