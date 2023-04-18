import 'package:flutter/material.dart';

import '../../styles.dart';

class BasicTitle extends StatelessWidget {
  final String text;

  const BasicTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold, color: DARK_GREEN));
  }
}
