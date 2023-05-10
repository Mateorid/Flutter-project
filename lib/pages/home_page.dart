import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/core/clickable_outlined_container.dart';
import 'package:pet_sitting/widgets/pet_overview_tile.dart';

import '../Models/Pet/pet.dart';
import '../ioc_container.dart';
import '../services/auth_service.dart';
import '../services/pet_service.dart';
import '../widgets/add_pet_tile.dart';
import '../widgets/core/bottom_navigation.dart';
import '../widgets/core/home_page_title.dart';
import '../widgets/global_snack_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  // final User? user = get<AuthService>().currentUser;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final petService = get<PetService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      bottomNavigationBar: BottomNavigation(),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: Center(
          child: ListView(
            children: [
              HomePageTitle(text: 'My listings', addCallback: () {}),
              const ClickableOutlinedContainer(
                child: SizedBox(
                  height: 50,
                  child: Center(
                    child: Text('You have no listings!'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              HomePageTitle(
                text: 'My pets',
                addCallback: () => {context.pushNamed('create_pet')},
              ),
              _listUserPets(),
              const AddPetCard(),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => {_onLogoutPressed(context)},
                child: const Text('Logout'),
              ),
              ElevatedButton(
                onPressed: () => {context.pushNamed('pet_profile')},
                child: const Text('TEST_PAGE'),
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _createAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        actions: [
          Transform.scale(
            scale: 2,
            child: IconButton(
              onPressed: () => {_onAccountPressed(context)},
              icon: Icon(
                shadows: [
                  Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 3.0)
                ],
                Icons.account_circle,
                color: MAIN_GREEN,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //todo make all these parts a widget
  Widget _listUserPets() {
    //todo stream builder
    return FutureBuilder(
      future: petService.getAllPets(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final petList = snapshot.data!;
          if (petList.isEmpty) {
            //todo
            return const ClickableOutlinedContainer(
              child: SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                      'You have no pets!\nClick on the + to add them\n//TODO'),
                ),
              ),
            );
          }
          return Column(children: _petOverviewWidgets(petList));
        }
        if (snapshot.hasError) {
          //todo
          return ErrorWidget(const Text('error has occurred'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  List<Widget> _petOverviewWidgets(List<Pet> pets) {
    final List<Widget> res = List.empty(growable: true);
    for (final e in pets) {
      res.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: PetOverviewTile(pet: e),
      ));
    }
    return res;
  }

  void _onAccountPressed(BuildContext context) {
    context.pushNamed('edit_user');
  }

  void _onLogoutPressed(BuildContext context) async {
    final AuthService authService = get<AuthService>();
    try {
      await authService.signOut();
      context.go('/login');
    } on FirebaseAuthException catch (e) {
      GlobalSnackBar.showAlertError(
          context: context,
          bigText: 'Error',
          smallText: e.message ?? 'Unknown error occurred');
    } catch (e) {
      GlobalSnackBar.showAlertError(
          context: context,
          bigText: 'Error',
          smallText: 'Unknown error, please try again later');
    }
  }
}
