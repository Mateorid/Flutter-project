import 'package:flutter/material.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/input_text_field.dart';
import 'package:email_validator/email_validator.dart';


class EmailValidationField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const EmailValidationField({Key? key, required this.hint, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputTextField(
      child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            icon: const Icon(
              Icons.person,
              color: DARK_GREEN,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            }
            if (!EmailValidator.validate(value!)) {
              return 'Please enter a valid email';
            }
          }),
    );
  }
}
