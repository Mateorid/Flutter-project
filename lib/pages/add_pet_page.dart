import 'package:flutter/material.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/Models/Pet/pet_size.dart';

import '../Models/Pet/pet_gender.dart';
import '../Models/Pet/pet_species.dart';
import '../ioc_container.dart';
import '../services/pet_service.dart';
import '../validators/name_validator.dart';
import '../widgets/form_dropdown.dart';
import '../widgets/plain_text_field.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _nameController = TextEditingController();
  late PetSpecies species;
  late PetGender gender;
  late PetSize size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(children: [
          PlainTextField(
            labelText: "Pet name*",
            placeholder: "Enter your pet's name",
            controller: _nameController,
            validator: nameValidator,
          ),
          FormDropDown(
            label: 'Gender*',
            hintText: "Select your pet's gender",
            items: PetGender.values
                .map((gender) => gender.toString().split('.')[1])
                .toList(),
            onChanged: (value) => {
              if (value != null)
                gender = gender = PetGender.values.firstWhere(
                  (e) => e.toString().split('.')[1] == value,
                  orElse: () => PetGender.other,
                )
            },
          ),
          FormDropDown(
            label: 'Species*',
            hintText: "Select your pet's species",
            items: PetSpecies.values //todo better
                .map((petSpecies) => petSpecies.toString().split('.')[1])
                .toList(),
            onChanged: (value) => {
              if (value != null)
                species = PetSpecies.values.firstWhere(
                  (e) => e.toString().split('.')[1] == value,
                  orElse: () => PetSpecies.other,
                )
            },
          ),
          Spacer(),
          ElevatedButton(
            onPressed: _onSavePressed,
            child: const Text("Add pet"),
          ),
          ElevatedButton(
            onPressed: _onGetPressed,
            child: const Text("Get pet"),
          ),
        ]),
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

  void _onGetPressed() async {
    final petService = get<PetService>();
    final pet = await petService.getPetById("fvU5zHnxbhsHK0407oMQ");
    if (pet == null) {
      print("FFS");
    } else {
      print(pet.name);
    }
  }
}
