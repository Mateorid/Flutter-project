import 'package:flutter/material.dart';
import 'package:pet_sitting/Models/Pet/pet_size.dart';
import 'package:pet_sitting/widgets/core/labeled_radio_button.dart';

class PetSizeSelect extends StatelessWidget {
  PetSizeSelect(
      {super.key,
      required this.size,
      required this.callback,
      required this.group});

  final PetSize size;
  final void Function(Object?) callback;
  final PetSize group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Select your pet\'s size:'),
            const Spacer(),
            LabeledRadioButton(
                label: const Text('S'),
                value: PetSize.small,
                groupValue: group,
                callback: callback),
            LabeledRadioButton(
                label: const Text('M'),
                value: PetSize.medium,
                groupValue: group,
                callback: callback),
            LabeledRadioButton(
                label: const Text('L'),
                value: PetSize.large,
                groupValue: group,
                callback: callback),
          ],
        ),
      ),
    );
  }
}
