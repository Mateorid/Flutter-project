import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/services/pet_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/pet_overview_tile.dart';

import '../../widgets/core/bottom_navigation.dart';

class PetsPage extends StatelessWidget {
  PetsPage({super.key});

  final _petService = GetIt.I<PetService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: _buildAddButton(context),
      body: _buildStreamBuilder(),
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
          return const Center(child: Text('Add your first pet!'));
        }
        return _buildListView(pets);
      },
    );
  }

  Widget _buildListView(List<Pet> pets) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Column(
                children: [
                  const SizedBox(height: 16),
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
