import 'package:flutter/material.dart';
import 'package:pet_sitting/Models/Pet/pet_gender.dart';
import 'package:pet_sitting/Models/Pet/pet_size.dart';

class IconService {
  IconData getGenderIcon(PetGender gender) {
    switch (gender) {
      case PetGender.male:
        return Icons.male;
      case PetGender.female:
        return Icons.female;
      case PetGender.other:
        return Icons.question_mark;
    }
  }

  IconData getSizeIcon(PetSize size) {
    switch (size) {
      case PetSize.small:
        // TODO: Handle this case.
        break;
      case PetSize.medium:
        // TODO: Handle this case.
        break;
      case PetSize.large:
        // TODO: Handle this case.
        break;
    }
    return Icons.accessibility_new;
  }
}
