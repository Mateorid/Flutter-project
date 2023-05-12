import 'package:flutter/cupertino.dart';

class OutlinedContainer extends StatelessWidget {
  final double width;
  final Widget child;

  const OutlinedContainer({
    super.key,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: CupertinoColors.lightBackgroundGray,
        border: Border.all(width: 3, color: CupertinoColors.systemGrey),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: child,
    );
  }
}
