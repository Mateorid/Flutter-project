import 'package:flutter/material.dart';
import 'package:pet_sitting/styles.dart';

class FormDropDown extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final void Function(String?) onChanged;

  FormDropDown(
      {required this.label,
      required this.hintText,
      required this.items,
      required this.onChanged});

  @override
  _FormDropDownState createState() => _FormDropDownState();
}

class _FormDropDownState extends State<FormDropDown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: widget.label,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: widget.hintText,
          hintStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: selectedValue,
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: DARK_GREEN),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
          });
          widget.onChanged(newValue);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select ${_removeAsterisks(widget.label.toLowerCase())}';
          }
          return null;
        },
      ),
    );
  }

  String _removeAsterisks(String input) {
    return input.replaceAll('*', '');
  }
}
