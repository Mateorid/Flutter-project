import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/pages/page_template.dart';
import 'package:pet_sitting/services/auth_service.dart';
import 'package:pet_sitting/services/pet_service.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/pets/pet_overview_tile.dart';
import 'package:pet_sitting/widgets/core/widget_future_builder.dart';

class PetsPage extends StatelessWidget {
  PetsPage({super.key});

  final _petService = get<PetService>();
  final _authService = get<AuthService>();
  final _userService = get<UserService>();

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
    return WidgetFutureBuilder(
        future: _userService.getUserById(_authService.currentUserId!),
        onLoaded: _buildStreamBuilder);
  }

  Widget _buildStreamBuilder(UserExtended user) {
    return StreamBuilder<List<Pet>>(
      stream: _petService.petStreamFromIds(user.pets),
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

  Widget _buildNotLoggedInInfo() {
    //Todo make nicer
    return const Center(child: Text('Login to add your pets!'));
  }

  Widget _buildNoPetsInfo() {
    //Todo make nicer
    return const Center(child: Text('Add your first pet!'));
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
