import 'package:flutter/material.dart';
import 'package:pet_sitting/Models/pet.dart';
import 'package:pet_sitting/Models/pet_size.dart';
import 'package:pet_sitting/Models/pet_species.dart';
import 'package:pet_sitting/widgets/core/info_tile.dart';

import '../Models/Gender.dart';

class PetProfilePage extends StatelessWidget {
  PetProfilePage({super.key});

  //todo I will have to load this info from DB
  final _pet = Pet(
    id: "id",
    name: "Doggo",
    gender: Gender.male,
    species: PetSpecies.dog,
    birthday: DateTime.now(),
    size: PetSize.medium,
    breed: "Labradoodle",
    details:
        "A good boy LOOOOOOOOOOOOOOOOOOOOOOOOONG TEEEEEEEEEEEEEEEEEEEEEEEEEEEXT HEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEERRRRRRRRRRRRREEEEEEEEEEEEEEEEEEEEEEEEEE",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              pinned: true,
              expandedHeight: 250,
              actions: [_editButton()],
              flexibleSpace: FlexibleSpaceBar(background: _petPhoto())),
          SliverList(delegate: _petInfo(context)),
        ],
      ),
    );
  }

  Widget _petPhoto() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/dog_img.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SliverChildListDelegate _petInfo(BuildContext context) {
    final p = _pet;
    return SliverChildListDelegate(
      [
        InfoTile(
          title: "Name",
          content: _infoText(p.name),
          icon: Icons.pets_rounded,
        ),
        InfoTile(
          title: "Species",
          content: _infoText(p.species.toString()),
          icon: Icons.info_outline,
        ),
        InfoTile(
          title: "Gender",
          content: _infoText(p.gender.toString()),
          icon: Icons.male, //todo set icon based on sex
        ),
        InfoTile(
          title: "PetSize",
          content: _infoText(p.size.toString()),
          icon: Icons.accessibility_new, //todo better
        ),
        //todo make this tappable and onclick it will change from Bday to age (scale it)
        InfoTile(
          title: "Birthday",
          content: _infoText(_getBirthdayText()),
          icon: Icons.cake_outlined,
          callback: () => print("//TODO: change to age"),
        ),
        InfoTile(
          title: "Breed",
          content: _infoText(p.breed.toString()),
          icon: Icons.pets_outlined,
        ),
        InfoTile(
          title: "Photos",
          content: _infoText("Photos will be here"),
          icon: Icons.image_outlined,
          callback: () => print("//TODO: open photo page"),
        ),
        InfoTile(
          title: "Details",
          content: _infoText(p.details.toString().length > 30
              ? "${p.details.toString().substring(0, 24)}..."
              : p.details.toString()),
          icon: Icons.question_mark,
          callback: _detailsCallback(context, p.details.toString()),
        ),
      ],
    );
  }

  Widget _editButton() {
    //todo render this only if user is owner
    return TextButton(
        onPressed: () {
          print("//TODO: open pet edit page");
        },
        child: const Text("Edit",
            style: TextStyle(fontSize: 20, color: Colors.white)));
  }

  Widget _infoText(String text) {
    return Text(text, style: const TextStyle(fontSize: 20));
  }

  String _getBirthdayText() {
    final dt = _pet.birthday;
    return dt == null ? 'No info' : '${dt.day}. ${dt.month}. ${dt.year}';
  }

  VoidCallback _detailsCallback(BuildContext context, String text) {
    return () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        ),
      );
    };
  }
}
