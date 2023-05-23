import 'package:flutter/widgets.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/Models/Pet/pet_species.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';

class ImageService {
  ImageProvider getPetImage(Pet? pet) {
    if (pet == null) {
      return const AssetImage('assets/images/no_image.PNG');
    }
    if (pet.imageUrl != null) {
      return NetworkImage(pet.imageUrl!);
    }
    switch (pet.species) {
      case PetSpecies.dog:
        return const AssetImage('assets/images/dog_img2.jpg');
      case PetSpecies.cat:
        return const AssetImage('assets/images/cat_img.jpg');
      case PetSpecies.bird:
        return const AssetImage('assets/images/bird_img.jpg');
      case PetSpecies.reptile:
        return const AssetImage('assets/images/reptile_img.jpg');
      case PetSpecies.smallMammal:
        return const AssetImage('assets/images/mammal_img.jpg');
      case PetSpecies.amphibian:
        return const AssetImage('assets/images/amphibian_img.jpg');
      case PetSpecies.other:
        return const AssetImage('assets/images/other_img.jpg');
    }
  }

  ImageProvider getUserImage(UserExtended user) {
    if (user.imageUrl == null) {
      return const AssetImage('assets/images/no_image.PNG');
    }
    return NetworkImage(user.imageUrl!);
  }
}
