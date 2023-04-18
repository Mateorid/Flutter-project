import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/add_pet_tile.dart';
import 'package:pet_sitting/widgets/basic_title.dart';

import '../ioc_container.dart';
import '../services/auth_service.dart';
import '../widgets/global_snack_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = get<AuthService>().currentUser;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
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
                    Shadow(
                        color: Colors.black.withOpacity(0.2), blurRadius: 3.0)
                  ],
                  Icons.account_circle,
                  color: MAIN_GREEN,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: Center(
          child: ListView(
            children: [
              BasicTitle(text: 'My pets'),
              const AddPetCard(),
              ElevatedButton(
                onPressed: () => {_onLogoutPressed(context)},
                child: Text('Logout'),
              ),
              ElevatedButton(
                onPressed: () => {context.pushNamed("pet_profile")},
                child: Text('TEST_PAGE'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onAccountPressed(BuildContext context) {
    context.pushNamed("edit_user");
  }

  void _onLogoutPressed(BuildContext context) async {
    final AuthService authService = get<AuthService>();
    try {
      await authService.signOut();
      context.go('/login');
    } on FirebaseAuthException catch (e) {
      GlobalSnackBar.showAlertError(
          context: context,
          bigText: "Error",
          smallText: e.message ?? 'Unknown error occurred');
    } catch (e) {
      GlobalSnackBar.showAlertError(
          context: context,
          bigText: "Error",
          smallText: 'Unknown error, please try again later');
    }
  }
}
