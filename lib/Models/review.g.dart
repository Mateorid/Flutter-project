// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      json['rating'] as int,
      json['text'] as String,
      json['fromUser'] as String,
      $enumDecode(_$UserTypeEnumMap, json['userType']),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'rating': instance.rating,
      'text': instance.text,
      'fromUser': instance.fromUser,
      'userType': _$UserTypeEnumMap[instance.userType]!,
    };

const _$UserTypeEnumMap = {
  UserType.owner: 'owner',
  UserType.sitter: 'sitter',
};
