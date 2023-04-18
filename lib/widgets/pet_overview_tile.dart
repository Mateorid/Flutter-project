import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/services/icon_service.dart';
import 'package:pet_sitting/widgets/core/content_with_label.dart';

import '../Models/Pet/pet.dart';
import '../ioc_container.dart';
import 'core/clickable_outlined_container.dart';

class PetOverviewTile extends StatelessWidget {
  PetOverviewTile({super.key, required this.pet});

  final Pet pet;
  final IconService iconService = get<IconService>();

  @override
  Widget build(BuildContext context) {
    return ClickableOutlinedContainer(
      onTap: () => {context.pushNamed('pet_profile')},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _petProfileImage(),
            ContentWithLabel(content: Text(pet.name), label: "name:"),
            ContentWithLabel(
              content: Icon(iconService.getGenderIcon(pet.gender)),
              label: "gender:",
            ),
            ContentWithLabel(
              content: Icon(iconService.getSizeIcon(pet.size)),
              label: "size:",
            ),
          ],
        ),
      ),
    );
  }

  Widget _petProfileImage() {
    return Container(
      height: 60.0,
      width: 60.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/images/dog_img.jpg'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
