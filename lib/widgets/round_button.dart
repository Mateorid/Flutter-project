import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onPressed;

  const RoundButton(
      {Key? key,
      required this.color,
      required this.text,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            // padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}
