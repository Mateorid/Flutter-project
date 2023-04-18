import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_sitting/Models/Pet/pet_gender.dart';
import 'package:pet_sitting/Models/Pet/pet_size.dart';
import 'package:pet_sitting/handle_async_operation.dart';
import 'package:pet_sitting/services/pet_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/core/basic_title.dart';
import 'package:pet_sitting/widgets/form_dropdown.dart';
import 'package:pet_sitting/widgets/pet_size_select.dart';
import 'package:pet_sitting/widgets/plain_text_field.dart';
import 'package:pet_sitting/widgets/round_button.dart';

import '../Models/Pet/pet.dart';
import '../Models/Pet/pet_species.dart';
import '../ioc_container.dart';
import '../services/auth_service.dart';
import '../validators/name_validator.dart';

class EditPetPage extends StatefulWidget {
  EditPetPage({Key? key, this.petId}) : super(key: key);

  final String? petId;
  final User? user = get<AuthService>().currentUser;

  @override
  EditPetPageState createState() => EditPetPageState();
}

class EditPetPageState extends State<EditPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _breedController = TextEditingController();
  final _detailsController = TextEditingController();

  late PetGender gender;
  late PetSpecies species;
  PetSize size = PetSize.medium; //todo or load from pet when update
  DateTime? birthday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DARK_GREEN),
          onPressed: () => {context.pop()},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const BasicTitle(text: 'ADD PET'),
            const SizedBox(height: 35),
            _buildForm(),
            RoundButton(
              color: MAIN_GREEN,
              text: 'SAVE',
              onPressed: () => _onSubmitPressed(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
            onChanged: _genderSelected,
          ),
          FormDropDown(
            label: 'Species*',
            hintText: "Select your pet's species",
            items: PetSpecies.values
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
          PetSizeSelect(
            size: size,
            callback: (val) {
              setState(() {
                size = val as PetSize;
              });
            },
            group: size,
          ),
          TextField(
            controller: _birthdayController,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today), //icon of text field
              labelText: "Enter birthday",
            ),
            readOnly: true,
            onTap: _birthdayOnTap,
          ),
          PlainTextField(
            labelText: "Breed",
            placeholder: "Further specify breed or species",
            controller: _breedController,
            validator: (value) => null,
          ),
          PlainTextField(
            labelText: "Details",
            placeholder: "Provide additional details about your pet",
            controller: _detailsController,
            validator: (value) => null,
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    final PetService petService = get<PetService>();
    final pet = Pet(
      name: _nameController.text,
      gender: gender,
      species: species,
      size: size,
      birthday: birthday,
      breed: _breedController.text,
      details: _detailsController.text,
    );
    await petService.createNewPet(pet);
  }

  void _onSubmitPressed() async {
    if (_formKey.currentState!.validate()) {
      if (await handleAsyncOperation(
          asyncOperation: _saveChanges(),
          onSuccessText: 'Pet profile creates',
          context: context)) context.pop();
    }
  }

  void _genderSelected(String? value) {
    if (value != null) {
      gender = gender = PetGender.values.firstWhere(
        (e) => e.toString().split('.')[1] == value,
        orElse: () => PetGender.other,
      );
    }
  }

  void _birthdayOnTap() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (date != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      setState(() {
        birthday = date;
        _birthdayController.text = formattedDate;
      });
    }
  }
}
