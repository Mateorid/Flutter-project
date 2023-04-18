import 'package:flutter/material.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/Models/Pet/pet_size.dart';

import '../Models/Pet/pet_gender.dart';
import '../Models/Pet/pet_species.dart';
import '../ioc_container.dart';
import '../services/pet_service.dart';

class AddPetPage extends StatelessWidget {
  const AddPetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: _onSavePressed,
          child: const Text("Add pet"),
        ),
      ),
    );
  }

  void _onSavePressed() async {
    final petService = get<PetService>();
    final pet = Pet(
      name: 'Test1',
      gender: PetGender.female,
      species: PetSpecies.dog,
      size: PetSize.medium,
      birthday: DateTime.now(),
      breed: "Poop",
      details: "Detailsgksadjglasdjg",
    );
    await petService.createNewPet(pet);
  }
}
