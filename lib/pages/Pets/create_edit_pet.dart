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
import 'package:pet_sitting/validators/gender_validator.dart';
import 'package:pet_sitting/validators/name_validator.dart';
import 'package:pet_sitting/validators/species_validator.dart';
import 'package:pet_sitting/widgets/pets/pet_size_select.dart';
import 'package:pet_sitting/widgets/plain_text_field.dart';
import 'package:pet_sitting/widgets/user/profile_widget.dart';

class CreateEditPet extends StatefulWidget {
  CreateEditPet({Key? key, this.pet}) : super(key: key);

  final Pet? pet;
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
  bool _loading = false;

  PetGender? gender;
  PetSpecies? species;
  String? url;
  bool imageUpdated = false;
  PetSize size = PetSize.medium;
  DateTime? birthday;

  @override
  void initState() {
    super.initState();

    if (widget.pet != null) {
      _setControllers(widget.pet!);
    }
  }

  void _setControllers(Pet pet) {
    size = pet.size;
    species = pet.species;
    gender = pet.gender;
    if (!imageUpdated) {
      url = pet.imageUrl;
    }
    _nameController.text = pet.name;
    _breedController.text = pet.breed ?? '';
    _detailsController.text = pet.details ?? '';
    _birthdayController.text = pet.birthday != null
        ? DateFormat('yyyy-MM-dd').format(pet.birthday!)
        : '';
  }

  @override
  Widget build(BuildContext context) {
    final edit = widget.pet != null;

    return CreateEditPageTemplate(
      pageTitle: edit ? 'Edit pet' : 'Add pet',
      buttonText: edit ? 'EDIT' : 'SAVE',
      buttonCallback: _onSubmitPressed,
      isLoading: _loading,
      body: _buildContent(widget.pet),
    );
  }

  Widget _buildContent(Pet? pet) {
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

  Widget _buildPhoto(Pet? pet) {
    final imageProvider = imageUpdated
        ? NetworkImage(url!)
        : widget._imageService.getPetImage(pet);
    return ProfileWidget(
        image: imageProvider,
        onTap: () async {
          String? url = await context.pushNamed(
            "upload_pet_image",
            params: {"id": "1"},
          );
          if (url != null) {
            setState(() {
              imageUpdated = true;
              this.url = url;
            });
          }
        });
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
          _genderDropdown(),
          const SizedBox(height: 20),
          _speciesDropdown(),
          const SizedBox(height: 20),
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

  Widget _speciesDropdown() {
    return DropdownButtonFormField<PetSpecies>(
      hint: const Text('Select species'),
      value: species,
      validator: speciesValidator,
      onChanged: (value) {
        if (value != null) {
          species = value;
        }
      },
      items: PetSpecies.values.map((s) {
        return DropdownMenuItem<PetSpecies>(
          value: s,
          child: Text(s.text),
        );
      }).toList(),
    );
  }

  Widget _genderDropdown() {
    return DropdownButtonFormField<PetGender>(
      hint: const Text('Select gender'),
      value: gender,
      validator: genderValidator,
      onChanged: (value) {
        if (value != null) {
          gender = value;
        }
      },
      items: PetGender.values.map((g) {
        return DropdownMenuItem<PetGender>(
          value: g,
          child: Text(g.text),
        );
      }).toList(),
    );
  }

  Future<void> _createPet() async {
    final pet = Pet(
      name: _nameController.text,
      gender: gender!,
      species: species!,
      size: size,
      imageUrl: url,
      birthday: birthday,
      breed: _breedController.text,
      details: _detailsController.text,
    );
    final petId = await widget._petService.createNewPet(pet);
    widget._userService.addPetToCurrentUser(petId);
  }

  Future<void> _editPet() async {
    final newPet = widget.pet!.copyWith(
      name: _nameController.text,
      gender: gender,
      species: species,
      size: size,
      birthday: birthday,
      breed: _breedController.text,
      details: _detailsController.text,
      imageUrl: url,
    );
    await widget._petService.updatePet(widget.pet!.id!, newPet);
  }

  void _onSubmitPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      await handleAsyncOperation(
        asyncOperation: widget.pet == null ? _createPet() : _editPet(),
        onSuccessText: widget.pet == null
            ? 'Pet successfully added'
            : 'Pet successfully edited',
        context: context,
      );

      if (context.mounted) {
        context.pop();
        setState(() {
          _loading = false;
        });
      }
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
