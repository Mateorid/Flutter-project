import 'package:flutter/material.dart';

class ContentWithLabel extends StatelessWidget {
  const ContentWithLabel(
      {super.key, required this.content, required this.label});

  final Widget content;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        content
      ],
    );
  }
}
