// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pet _$PetFromJson(Map<String, dynamic> json) => Pet(
      id: json['id'] as String?,
      name: json['name'] as String,
      gender: json['gender'],
      species: $enumDecodeNullable(_$PetSpeciesEnumMap, json['species']),
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      size: $enumDecodeNullable(_$PetSizeEnumMap, json['size']),
      breed: json['breed'] as String?,
      details: json['details'] as String?,
    );

Map<String, dynamic> _$PetToJson(Pet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': _$GenderEnumMap[instance.gender],
      'species': _$PetSpeciesEnumMap[instance.species],
      'size': _$PetSizeEnumMap[instance.size],
      'birthday': instance.birthday?.toIso8601String(),
      'breed': instance.breed,
      'details': instance.details,
    };

const _$GenderEnumMap = {
  Gender.female: 'female',
  Gender.male: 'male',
  Gender.other: 'other',
};

const _$PetSpeciesEnumMap = {
  PetSpecies.dog: 'dog',
  PetSpecies.cat: 'cat',
  PetSpecies.bird: 'bird',
  PetSpecies.reptile: 'reptile',
  PetSpecies.smallMammal: 'smallMammal',
  PetSpecies.amphibian: 'amphibian',
  PetSpecies.other: 'other',
};

const _$PetSizeEnumMap = {
  PetSize.small: 'small',
  PetSize.medium: 'medium',
  PetSize.large: 'large',
};
