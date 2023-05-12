// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_extended.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserExtended _$UserExtendedFromJson(Map<String, dynamic> json) => UserExtended(
      uid: json['uid'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      location: json['location'] as String?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      aboutMe: json['aboutMe'] as String?,
      pets:
          (json['pets'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserExtendedToJson(UserExtended instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'name': instance.name,
      'location': instance.location,
      'aboutMe': instance.aboutMe,
      'imageUrl': instance.imageUrl,
      'pets': instance.pets,
      'reviews': instance.reviews,
    };
