import 'package:flutter/material.dart';
import 'package:pet_sitting/widgets/core/basic_title.dart';

class PageTemplate extends StatelessWidget {
  const PageTemplate({super.key, required this.pageTitle, required this.body});

  final String pageTitle;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BasicTitle(text: pageTitle),
          ), //todo make this nicer?
          Expanded(child: body),
        ],
      ),
    );
  }
}
