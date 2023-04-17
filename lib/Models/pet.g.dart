// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pet _$PetFromJson(Map<String, dynamic> json) => Pet(
      json['uid'] as String,
      json['name'] as String,
      json['gender'],
      $enumDecodeNullable(_$PetSpeciesEnumMap, json['species']),
      json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      $enumDecodeNullable(_$PetSizeEnumMap, json['size']),
      json['breed'] as String?,
      json['details'] as String?,
    );

Map<String, dynamic> _$PetToJson(Pet instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'gender': instance.gender,
      'species': _$PetSpeciesEnumMap[instance.species],
      'size': _$PetSizeEnumMap[instance.size],
      'birthday': instance.birthday?.toIso8601String(),
      'breed': instance.breed,
      'details': instance.details,
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
