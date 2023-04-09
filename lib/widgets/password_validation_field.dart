import 'package:flutter/material.dart';
import 'package:pet_sitting/styles.dart';
import 'package:pet_sitting/widgets/input_text_field.dart';

class PassWordValidationField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final String? matchValue;
  final Function(String name)? onChanged;

  const PassWordValidationField(
      {Key? key, required this.hint, this.controller, this.matchValue, this.onChanged})
      : super(key: key);

  @override
  _PassWordValidationFieldState createState() =>
      _PassWordValidationFieldState();
}

class _PassWordValidationFieldState extends State<PassWordValidationField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return InputTextField(
      child: TextFormField(
        onChanged: widget.onChanged,
          controller: widget.controller, // using ternary operator
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: widget.hint,
            icon: Icon(
              Icons.lock,
              color: darkGreen,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: darkGreen,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            }
            if (value.length < 6) {
              return 'Password should have more than 6 characters';
            }
            if (widget.matchValue != null && widget.matchValue != value){
              print (widget.matchValue);
              return "Passwords don't match";
            }
          }),
    );
  }
}
