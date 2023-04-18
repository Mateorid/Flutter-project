import 'package:flutter/material.dart';

import 'basic_title.dart';

class HomePageTitle extends StatelessWidget {
  const HomePageTitle({super.key, required this.text, this.addCallback});

  final String text;
  final VoidCallback? addCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BasicTitle(text: text),
        const Spacer(),
        IconButton(onPressed: addCallback, icon: const Icon(Icons.add))
      ],
    );
  }
}
