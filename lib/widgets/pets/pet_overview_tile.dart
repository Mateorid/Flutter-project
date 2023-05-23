import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/services/date_service.dart';
import 'package:pet_sitting/services/image_service.dart';
import 'package:pet_sitting/styles.dart';

class PetOverviewTile extends StatelessWidget {
  PetOverviewTile({super.key, required this.pet});

  final Pet pet;
  final _dateService = get<DateService>();
  final _imageService = get<ImageService>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('pet_profile', extra: pet);
      },
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image(image: _imageService.getPetImage(pet)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 18),
                _petName(pet.name),
                const SizedBox(width: 15),
                _optionalPetInfo(pet)
              ],
            ),
            _petInfo(pet),
            // const Divider(),
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
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 5),
      child: Text(
        '${pet.size.text} / ${pet.gender.text} / ${pet.species.text}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _optionalPetInfo(Pet pet) {
    final text =
        '${pet.birthday != null ? '${_dateService.getAgeFromDate(pet.birthday!)} ${pet.breed != null ? '- ' : ''}' : ''}${pet.breed} ';
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
