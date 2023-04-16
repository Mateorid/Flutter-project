import 'package:flutter/material.dart';
import 'package:pet_sitting/styles.dart';

class PlainTextField extends StatelessWidget {
  final String labelText;
  final String placeholder;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  bool extended;

   PlainTextField(
      {Key? key,
      required this.labelText,
      required this.placeholder,
      required this.controller,
      required this.validator,
      this.extended = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: TextFormField(
          minLines: extended? 3 : 1,
          maxLines: null,
          controller: controller,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: DARK_GREEN,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
          ),
          validator: validator,
        ));
  }
}
