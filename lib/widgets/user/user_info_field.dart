import 'package:flutter/material.dart';
import 'package:pet_sitting/styles.dart';

class UserInfoField extends StatelessWidget {
  final IconData icon;
  final String text;

  const UserInfoField({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 30,
          color: MAIN_GREEN,
        ),
        const SizedBox(width: 15),
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
