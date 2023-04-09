import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ioc_container.dart';
import '../services/auth_service.dart';
import '../widgets/global_snack_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        ElevatedButton(
          child: Text("Logout"),
          onPressed: () => {_onLogoutPressed(context)},
        )
      ]),
    );
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
