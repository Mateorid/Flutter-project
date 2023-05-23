import 'package:flutter/material.dart';
import 'package:pet_sitting/Models/Pet/pet_gender.dart';

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
}
