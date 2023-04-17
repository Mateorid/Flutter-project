import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/pet.dart';
import 'package:pet_sitting/Models/pet_species.dart';
import 'package:pet_sitting/widgets/core/info_tile.dart';

import '../Models/Gender.dart';
import '../styles.dart';

class PetProfilePage extends StatefulWidget {
  PetProfilePage({super.key});

  //todo I will have to load this info from DB?
  final _pet = Pet(
    id: "bla",
    name: "Muffin",
    gender: Gender.male,
    species: PetSpecies.dog,
  );

  @override
  _PetProfilePageState createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
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
          ),
        ),
      ),
      body: Container(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            _petPhoto(),
            SizedBox(height: 10),
            InfoTile(title: "Name", content: Text("XDD")),
            SizedBox(height: 10),
            InfoTile(title: "Type", content: Text("XDD")),
            SizedBox(height: 10),
            InfoTile(content: Text("XDD")),
          ]),
        ),
      )),
    );
  }

  Widget _petPhoto() {
    return Container(
      height: 120.0,
      width: 120.0,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/dog_img.jpg'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
