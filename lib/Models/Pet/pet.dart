import 'package:json_annotation/json_annotation.dart';
import 'package:pet_sitting/Models/Pet/pet_gender.dart';
import 'package:pet_sitting/Models/Pet/pet_size.dart';
import 'package:pet_sitting/Models/Pet/pet_species.dart';

part 'pet.g.dart';

@JsonSerializable()
class Pet {
  String? id;
  final String name;
  final PetGender gender;
  final PetSpecies species;
  final PetSize size;
  final DateTime? birthday;
  final String? breed;
  final String? details;
  final String? imageUrl;

  Pet(
      {this.id,
      required this.name,
      required this.gender,
      required this.species,
      required this.size,
      this.birthday,
      this.breed,
      this.imageUrl,
      this.details});

  Pet copyWith({
    String? id,
    String? name,
    PetGender? gender,
    PetSpecies? species,
    PetSize? size,
    DateTime? birthday,
    String? breed,
    String? details,
    String? imageUrl,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      species: species ?? this.species,
      size: size ?? this.size,
      birthday: birthday ?? this.birthday,
      breed: breed ?? this.breed,
      details: details ?? this.details,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

  Map<String, dynamic> toJson() => _$PetToJson(this);
}
