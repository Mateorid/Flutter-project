import 'package:flutter/material.dart';

import '../../styles.dart';

class ClickableOutlinedContainer extends StatelessWidget {
  const ClickableOutlinedContainer(
      {super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3, color: MAIN_GREEN),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: child,
      ),
    );
  }
}
