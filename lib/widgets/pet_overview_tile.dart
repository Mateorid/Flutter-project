import 'package:flutter/material.dart';

import '../Models/Pet/pet.dart';

class PetOverviewTile extends StatelessWidget {
  const PetOverviewTile({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(pet.name)],
    );
  }
}
