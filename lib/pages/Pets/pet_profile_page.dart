import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/services/date_service.dart';
import 'package:pet_sitting/services/icon_service.dart';
import 'package:pet_sitting/services/image_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/core/info_tile.dart';

class PetProfilePage extends StatelessWidget {
  PetProfilePage({super.key, required this.pet});

  final Pet pet;
  final _iconService = get<IconService>();
  final _dateService = get<DateService>();
  final _imageService = get<ImageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            actions: [_editButton(pet, context)],
            flexibleSpace: FlexibleSpaceBar(background: _petPhoto()),
          ),
          SliverList(delegate: _petInfo(context)),
        ],
      ),
    );
  }

  Widget _petPhoto() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _imageService.getPetImage(pet),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SliverChildListDelegate _petInfo(BuildContext context) {
    final p = pet;
    return SliverChildListDelegate(
      [
        InfoTile(
          title: "Name",
          content: _infoText(p.name),
          icon: Icons.pets_rounded,
        ),
        InfoTile(
          title: "Species",
          content: _infoText(p.species.text),
          icon: Icons.info_outline,
        ),
        InfoTile(
          title: "Gender",
          content: _infoText(p.gender.text),
          icon: _iconService.getGenderIcon(p.gender),
        ),
        InfoTile(
          title: "PetSize",
          content: _infoText(p.size.text),
          icon: _iconService.getSizeIcon(p.size),
        ),
        InfoTile(
          title: "Breed",
          content: _infoText(p.breed.toString()),
          icon: Icons.pets_outlined,
        ),
        //todo make this tappable and onclick it will change from Bday to age (scale it)
        InfoTile(
          title: "Birthday",
          content: _infoText(_getBirthdayText()),
          icon: Icons.cake_outlined,
          callback: () => print("//TODO: change to age"),
        ),
        //todo open images?
        InfoTile(
          title: "Photos",
          content: _infoText("Click to show 9+ more photos"), //todo?
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

  Widget _editButton(Pet pet, BuildContext context) {
    //todo render this only if user is owner
    return TextButton(
        onPressed: () {
          context.pushNamed("edit_pet", params: {"id": pet.id!});
        },
        child: const Text("Edit",
            style: TextStyle(fontSize: 20, color: MAIN_GREEN)));
  }

  Widget _infoText(String text) {
    return Text(text, style: const TextStyle(fontSize: 20));
  }

  String _getBirthdayText() {
    final dt = pet.birthday;
    return dt == null ? 'No info' : _dateService.getPrintableDate(dt);
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
