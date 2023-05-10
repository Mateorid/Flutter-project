import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/storage_service.dart';
import '../../styles.dart';

class UserRoundImage extends StatelessWidget {

  final double size;
  final String? url;
  final _storageService = GetIt.I<StorageService>();
  UserRoundImage({Key? key, required this.size, this.url}) : super(key: key);

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
            image: DecorationImage(
                fit: BoxFit.cover,
              image: url != null
                  ? NetworkImage(url!)
                  : const AssetImage('assets/images/no_image.PNG') as ImageProvider,
                )
            ));
  }

}
