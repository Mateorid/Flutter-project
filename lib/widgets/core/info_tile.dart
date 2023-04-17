import 'package:flutter/material.dart';

import '../../styles.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.content, this.title});

  final Widget content;
  final String? title;

  final Icon? _iconL = const Icon(
    Icons.cake_outlined,
    color: MAIN_GREEN,
    size: 30.0,
  );
  final Icon? _iconR = const Icon(
    Icons.arrow_forward_ios,
    color: MAIN_GREEN,
    size: 30.0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: MAIN_GREEN,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // const SizedBox(width: 10),
            if (_iconL != null) _iconL!,
            // const SizedBox(width: 10),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    if (title != null)
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          title!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    Align(alignment: Alignment.centerLeft, child: content),
                  ],
                ),
              ),
            ),
            _iconR!,
            // const SizedBox(width: 5)
          ],
        ),
      ),
    );
  }
}
