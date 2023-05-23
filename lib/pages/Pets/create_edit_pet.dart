import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/Models/Pet/pet_gender.dart';
import 'package:pet_sitting/Models/Pet/pet_size.dart';
import 'package:pet_sitting/Models/Pet/pet_species.dart';
import 'package:pet_sitting/handle_async_operation.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/pages/create_edit_page_template.dart';
import 'package:pet_sitting/services/image_service.dart';
import 'package:pet_sitting/services/pet_service.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/validators/name_validator.dart';
import 'package:pet_sitting/widgets/core/widget_stream_builder.dart';
import 'package:pet_sitting/widgets/form_dropdown.dart';
import 'package:pet_sitting/widgets/pets/pet_size_select.dart';
import 'package:pet_sitting/widgets/plain_text_field.dart';
import 'package:pet_sitting/widgets/user/profile_widget.dart';

class CreateEditPet extends StatefulWidget {
  CreateEditPet({Key? key, this.petId}) : super(key: key);

  final String? petId;
  final _petService = get<PetService>();
  final _userService = get<UserService>();
  final _imageService = get<ImageService>();

  @override
  CreateEditPetState createState() => CreateEditPetState();
}

class CreateEditPetState extends State<CreateEditPet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _breedController = TextEditingController();
  final _detailsController = TextEditingController();

  late PetGender gender;
  late PetSpecies species;
  PetSize size = PetSize.medium;
  DateTime? birthday;

  @override
  Widget build(BuildContext context) {
    final edit = widget.petId != null;

    return CreateEditPageTemplate(
      pageTitle: edit ? 'Edit pet' : 'Add pet',
      buttonText: edit ? 'EDIT' : 'SAVE',
      buttonCallback: _onSubmitPressed,
      body: edit
          ? WidgetStreamBuilder<Pet?>(
              stream: widget._petService.getPetById(widget.petId!),
              onLoaded: _buildContent,
            )
          : _buildContent(null),
    );
  }

  Widget _buildContent(Pet? pet) {
    if (pet != null) {
      _setControllers(pet);
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          _buildPhoto(pet),
          _buildForm(),
        ],
      ),
    );
  }

  void _setControllers(Pet pet) {
    // setState(() { //todo
    size = pet.size;
    species = pet.species;
    // });
    gender = pet.gender;
    _nameController.text = pet.name;
    _breedController.text = pet.breed ?? '';
    _detailsController.text = pet.details ?? '';
    _birthdayController.text = pet.birthday != null
        ? DateFormat('yyyy-MM-dd').format(pet.birthday!)
        : '';
  }

  Widget _buildPhoto(Pet? pet) {
    return ProfileWidget(
      image: widget._imageService.getPetImage(pet),
      onTap: () {}, //todo
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
            //todo better
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
            items: PetSpecies.values //todo show better names
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
    final pet = Pet(
      name: _nameController.text,
      gender: gender,
      species: species,
      size: size,
      birthday: birthday,
      breed: _breedController.text,
      details: _detailsController.text,
    );
    final petId = await widget._petService.createNewPet(pet);
    widget._userService.addPetToCurrentUser(petId);
  }

  void _onSubmitPressed() async {
    if (_formKey.currentState!.validate()) {
      final ok = await handleAsyncOperation(
          asyncOperation: _saveChanges(),
          onSuccessText: 'Pet successfully added',
          context: context);
      if (ok && context.mounted) {
        context.pop();
      }
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
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (date != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      setState(() {
        birthday = date;
        _birthdayController.text = formattedDate;
      });
    }
  }
}
