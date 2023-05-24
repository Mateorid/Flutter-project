import 'package:pet_sitting/Models/Pet/pet_gender.dart';

String? Function(PetGender?)? genderValidator = (PetGender? value) {
  if (value == null) {
    return 'Enter your gender';
  }
  return null;
};
