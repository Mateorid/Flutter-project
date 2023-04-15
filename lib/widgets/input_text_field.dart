import 'package:flutter/material.dart';
import 'package:pet_sitting/styles.dart';

class InputTextField extends StatelessWidget {
  final Widget child;

  const InputTextField({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: lightGreen, borderRadius: BorderRadius.circular(29)),
      child: child,
    );
  }
}
