import 'package:flutter/material.dart';

class LabeledRadioButton extends StatelessWidget {
  const LabeledRadioButton(
      {super.key,
      required this.label,
      required this.value,
      required this.groupValue,
      required this.callback});

  final Widget label;
  final dynamic value;
  final dynamic groupValue;
  final void Function(dynamic) callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        label,
        Radio(value: value, groupValue: groupValue, onChanged: callback)
      ],
    );
  }
}
