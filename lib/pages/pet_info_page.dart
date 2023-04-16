import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/handle_async_operation.dart';
import 'package:pet_sitting/services/pet_service.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/basic_title.dart';
import 'package:pet_sitting/widgets/form_dropdown.dart';
import 'package:pet_sitting/widgets/plain_text_field.dart';
import 'package:pet_sitting/widgets/round_button.dart';
import '../Models/pet.dart';
import '../ioc_container.dart';
import '../services/auth_service.dart';
import '../validators/name_validator.dart';
import '../widgets/global_snack_bar.dart';
import 'package:email_validator/email_validator.dart';

class PetInfoPage extends StatefulWidget {
  PetInfoPage({Key? key}) : super(key: key);

  final User? user = get<AuthService>().currentUser;

  @override
  PetInfoPageState createState() => PetInfoPageState();
}

class PetInfoPageState extends State<PetInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _detailsController = TextEditingController();
  bool _loading = false;
  String gender = "";
  String species = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
              elevation: 1,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: DARK_GREEN,
                ),
                onPressed: () => {context.pop()},
              )),
        ),
        body: _loading
            ? const CircularProgressIndicator()
            : Container(
                padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
                child: ListView(
                  children: [
                    const BasicTitle(text: 'PET PROFILE'),
                    const SizedBox(
                      height: 35,
                    ),
                    _buildForm(),
                    const SizedBox(
                      height: 35,
                    ),
                    RoundButton(
                        color: MAIN_GREEN, text: 'SAVE', onPressed: () => _onSubmitPressed()),
                  ],
                )));
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
            items: const ['Male', 'Female'],
            onChanged: (value) => {if (value != null) gender = value},
          ),
          PlainTextField(
            labelText: "Pet age",
            placeholder: "Enter your pet's age",
            controller: _ageController,
            validator: (value) => null,
          ),
          PlainTextField(
            labelText: "Pet weight",
            placeholder: "Enter your pet's weight in kg",
            controller: _weightController,
            validator: (value) => null,
          ),
          FormDropDown(
            label: 'Species*',
            hintText: "Select your pet's species",
            items: const [
              'Dog',
              'Cat',
              'Bird',
              'Small Mammal',
              'Reptile',
              'Amphibian',
              'Other'
            ],
            onChanged: (value) => {if (value != null) species = value},
          ),
          PlainTextField(
            labelText: "Breed",
            placeholder: "Further specify breed or species",
            controller: _speciesController,
            validator: (value) => null,
          ),
          PlainTextField(
            labelText: "Details",
            placeholder: "Provide additional details about your pet",
            controller: _detailsController,
            validator: (value) => null,
            extended: true,
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    final id = get<AuthService>().currentUserId;
    final PetService petService = get<PetService>();
    if (id != null){
      Pet pet = Pet(
        ownerId: id,
        name: _nameController.text,
        gender: gender,
        age: _ageController.text,
        weight: _weightController.text,
        species: species,
        breed: _speciesController.text,
        details: _detailsController.text,
      );
      await petService.createNewPet(pet);
    }
  }

  void _onSubmitPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      handleAsyncOperation(asyncOperation: _saveChanges(), onSuccessText: 'Pet profile creates', context: context);
      setState(() {
        _loading = false;
      });
      context.pop();
    }
  }
}