import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/services/auth_service.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/round_button.dart';

import '../ioc_container.dart';
import '../widgets/email_validation_field.dart';
import '../widgets/global_snack_bar.dart';
import '../widgets/password_validation_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String passwordMatch = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(child: _registerPageForm(context))));
  }

  Widget _registerPageForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Sign up",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: darkGreen)),
          const SizedBox(height: 5),
          Text("Create an account. It's free.",
              style: TextStyle(color: darkGreen)),
          _buildFields(),
          const SizedBox(height: 5),
          RoundButton(
            color: orangeColor,
            text: "REGISTER",
            onPressed: () {
              _onRegisterPressed();
            },
          ),
          const SizedBox(height: 5),
          _buildProgressIndicator(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an accout?"),
              TextButton(
                onPressed: () {
                  context.pushNamed("login");
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.centerLeft),
                child: const Text('Login.',
                    style: TextStyle(
                        color: mainGreen, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        EmailValidationField(
          hint: "Your email",
          controller: _emailController,
        ),
        PassWordValidationField(
          hint: "Password",
          controller: _passwordController,
          onChanged: (String value) {
            setState(() {
              passwordMatch = value;
            });
          },
        ),
        PassWordValidationField(
            hint: "Confirm password", matchValue: passwordMatch),
      ],
    );
  }

  void _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      final AuthService authService = get<AuthService>();
      try {
        await authService.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        GlobalSnackBar.showAlertSuccess(
            context: context,
            bigText: "Success",
            smallText: 'Account successfully created');
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
