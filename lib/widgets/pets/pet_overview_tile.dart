import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/Models/Pet/pet_gender.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/services/date_service.dart';
import 'package:pet_sitting/services/icon_service.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:pet_sitting/styles.dart';

class PetOverviewTile extends StatelessWidget {
  PetOverviewTile({super.key, required this.pet});

  final Pet pet;
  final IconService iconService = get<IconService>();
  final dateService = get<DateService>();

  final service = get<UserService>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('pet_profile', extra: pet);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              //todo load this properly?
              child: Image.asset('assets/images/dog_img2.jpg'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _petName(pet.name),
                const SizedBox(width: 15),
                _optionalPetInfo(pet)
              ],
            ),
            _petInfo(pet)
          ],
        ),
      ),
    );
  }

  Widget _petName(String name) {
    return Text(
      name,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: DARK_GREEN,
      ),
    );
  }

  Widget _petInfo(Pet pet) {
    String? genderText;
    switch (pet.gender) {
      case PetGender.male:
        genderText = 'boy / ';
        break;
      case PetGender.female:
        genderText = 'girl / ';
        break;
      case PetGender.other:
        break;
    }

    final text = '${pet.size.name} / ${genderText ?? ''}${pet.species.name}';
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }

  Widget _optionalPetInfo(Pet pet) {
    final text =
        '${pet.breed} ${pet.birthday != null ? dateService.getAgeFromDate(pet.birthday!) : ''}';
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.grey,
      ),
    );
  }
}
