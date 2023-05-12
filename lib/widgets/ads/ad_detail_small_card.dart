import 'package:flutter/material.dart';
import 'package:pet_sitting/styles.dart';

class AdDetailSmallCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const AdDetailSmallCard({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            width: size.width * 0.23,
            height: size.height * 0.06,
            child: _buildContent(size)),
      ),
    );
  }

  Widget _buildContent(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: MAIN_GREEN,
              size: size.height * 0.03,
            )
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Text(
              text,
            )
          ],
        )
      ],
    );
  }
}
