import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/pages/page_template.dart';
import 'package:pet_sitting/services/auth_service.dart';
import 'package:pet_sitting/services/pet_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/core/widget_stream_builder.dart';
import 'package:pet_sitting/widgets/pets/pet_overview_tile.dart';

class PetsPage extends StatelessWidget {
  PetsPage({super.key});

  final _petService = get<PetService>();
  final _authService = get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildAddButton(context),
      body: PageTemplate(
        pageTitle: 'My pets',
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_authService.currentUserId == null) {
      return _buildNotLoggedInInfo();
    }

    return WidgetStreamBuilder(
      stream: _petService.currentUserPetStream,
      onLoaded: (pets) {
        if (pets.isEmpty) {
          return _buildNoPetsInfo();
        }
        return _buildListView(pets);
      },
    );
  }

  Widget _buildNotLoggedInInfo() {
    return const Center(child: Text('Login to add your pets!'));
  }

  Widget _buildNoPetsInfo() {
    return Center(
      child: Column(
        children: [
          Image.asset('assets/images/petSitting.png'),
          const Text(
            'Add your first pet!',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: MAIN_GREEN),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Pet> pets) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
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
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: MAIN_GREEN,
      onPressed: () {
        context.pushNamed('create_pet');
      },
      child: const Icon(Icons.add),
    );
  }
}
