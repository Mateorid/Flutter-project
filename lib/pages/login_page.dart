import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/email_validation_field.dart';
import 'package:pet_sitting/widgets/password_validation_field.dart';
import 'package:pet_sitting/widgets/round_button.dart';

import '../ioc_container.dart';
import '../services/auth_service.dart';
import '../widgets/global_snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(child: _loginPageForm(context))));
  }

  Widget _loginPageForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/petSittingLighter.png"),
          Text("TODO: APP NAME",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: DARK_GREEN)),
          EmailValidationField(
            hint: "Your email",
            controller: _emailController,
          ),
          PassWordValidationField(
            hint: "Password",
            controller: _passwordController,
          ),
          const SizedBox(height: 5),
          RoundButton(
            color: ORANGE_COLOR,
            text: "LOGIN",
            onPressed: _onLoginPressed,
          ),
          _buildProgressIndicator(),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an accout yet?"),
              TextButton(
                onPressed: () {
                  context.pushNamed("register");
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.centerLeft),
                child: const Text('Sign up.',
                    style: TextStyle(
                        color: MAIN_GREEN, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      final AuthService authService = get<AuthService>();
      try {
        await authService.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        context.goNamed("pets");
      } on FirebaseAuthException catch (e) {
        GlobalSnackBar.showAlertError(
            context: context,
            bigText: "Error",
            smallText: "Account not found.");
      } catch (e) {
        GlobalSnackBar.showAlertError(
            context: context,
            bigText: "Error",
            smallText: 'Unknown error, please try again later');
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Widget _buildProgressIndicator() {
    return _loading ? CircularProgressIndicator() : Container();
  }
}
