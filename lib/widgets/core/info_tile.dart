import 'package:flutter/material.dart';

import '../../styles.dart';

class InfoTile extends StatelessWidget {
  const InfoTile(
      {super.key,
      required this.content,
      this.title,
      this.callback,
      this.icon,
      this.height = 80,
      this.width});

  final Widget content;
  final IconData? icon;
  final String? title;
  final VoidCallback? callback;
  final double? height;
  final double? width;

  final Icon _clickableIcon = const Icon(
    Icons.arrow_forward_ios,
    color: MAIN_GREEN,
    size: 30.0,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback ?? () {},
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: MAIN_GREEN),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0), //inner padding
            child: Row(
              children: [
                _generateIcon(),
                const SizedBox(width: 5),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_generateTitle(), content],
                  ),
                ),
                const Spacer(),
                _generateClickableIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _generateTitle() {
    return title != null
        ? Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )
        : const SizedBox.shrink();
  }

  Widget _generateIcon() {
    return icon != null
        ? Icon(icon, color: MAIN_GREEN, size: 40)
        : const SizedBox.shrink();
  }

  Widget _generateClickableIndicator() {
    return callback != null ? _clickableIcon : const SizedBox.shrink();
  }
}
