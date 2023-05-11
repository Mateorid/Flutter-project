import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double borderRadius;

  const RoundButton({
    Key? key,
    required this.color,
    required this.text,
    required this.onPressed,
    this.width = 0,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: width == 0 ? size.width * 0.8 : width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius == 0? 29 : borderRadius),
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
