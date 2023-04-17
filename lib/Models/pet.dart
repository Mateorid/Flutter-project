import 'package:json_annotation/json_annotation.dart';
import 'package:pet_sitting/Models/Gender.dart';
import 'package:pet_sitting/Models/pet_size.dart';
import 'package:pet_sitting/Models/pet_species.dart';

part 'pet.g.dart';

@JsonSerializable()
class Pet {
  final String uid;
  final String name;
  final Gender? gender; //todo unnullable
  final PetSpecies? species; //todo unnullable
  final PetSize? size; //todo unnullable
  final DateTime? birthday;
  final String? breed;
  final String? details;

  Pet(this.uid, this.name, this.gender, this.species, this.birthday, this.size,
      this.breed, this.details);

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

  Map<String, dynamic> toJson() => _$PetToJson(this);
}
