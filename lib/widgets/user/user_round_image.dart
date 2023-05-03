import 'package:flutter/material.dart';

import '../../styles.dart';

class UserRoundImage extends StatelessWidget {

  final double size;
  const UserRoundImage({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            border: Border.all(
                width: 4, color: Theme.of(context).scaffoldBackgroundColor),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 10))
            ],
            shape: BoxShape.circle,
            image: const DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  "https://www.gensoldx.com/wp-content/uploads/2017/06/cdn.akc_.orgwhy_life_is_better_with_d-d4168a4c5d58d6716e64ae4828e297751c32b51f.jpg",
                ))),
      );
  }

}
