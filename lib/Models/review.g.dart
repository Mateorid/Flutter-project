// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      rating: json['rating'] as int,
      text: json['text'] as String,
      fromUser: json['fromUser'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'rating': instance.rating,
      'text': instance.text,
      'dateTime': instance.dateTime.toIso8601String(),
      'fromUser': instance.fromUser,
    };
