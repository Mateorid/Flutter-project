import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/services/pet_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/core/basic_title.dart';
import 'package:pet_sitting/widgets/pets/pet_overview_tile.dart';

import '../../widgets/core/bottom_navigation.dart';

class PetsPage extends StatelessWidget {
  PetsPage({super.key});

  final _petService = GetIt.I<PetService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: _buildAddButton(context),
      body: _buildPageContent(),
    );
  }

  Widget _buildPageContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BasicTitle(text: 'Your pets'), //todo make this nicer
            Expanded(child: _buildStreamBuilder()),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamBuilder() {
    return StreamBuilder<List<Pet>>(
      stream: _petService.petStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final pets = snapshot.data!;
        if (pets.isEmpty) {
          return _buildNoPetsInfo();
        }
        return _buildListView(pets);
      },
    );
  }

  Widget _buildNoPetsInfo() {
    //Todo nicer
    return const Center(child: Text('Add your first pet!'));
  }

  Widget _buildListView(List<Pet> pets) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Column(
                children: [
                  PetOverviewTile(pet: pet),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: MAIN_GREEN,
      onPressed: () {
        context.pushNamed('create_pet');
      },
      child: const Icon(Icons.add),
    );
  }
}
