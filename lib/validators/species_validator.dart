import 'package:pet_sitting/Models/Pet/pet_species.dart';

String? Function(PetSpecies?)? speciesValidator = (PetSpecies? value) {
  if (value == null) {
    return 'Enter your species';
  }
  return null;
};
