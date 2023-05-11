// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ad _$AdFromJson(Map<String, dynamic> json) => Ad(
      id: json['id'] as String?,
      location: json['location'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      costPerHour: json['costPerHour'] as int,
      from: DateTime.parse(json['from'] as String),
      to: DateTime.parse(json['to'] as String),
      creatorId: json['creatorId'] as String,
      petId: json['petId'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$AdToJson(Ad instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'costPerHour': instance.costPerHour,
      'from': instance.from.toIso8601String(),
      'to': instance.to.toIso8601String(),
      'petId': instance.petId,
      'creatorId': instance.creatorId,
      'location': instance.location,
      'active': instance.active,
    };
