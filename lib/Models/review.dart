import 'package:json_annotation/json_annotation.dart';
import 'package:pet_sitting/Models/user_type.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final int rating; //0-5 *
  final String text;
  final DateTime dateTime;
  final String fromUser;

  Review({required this.rating, required this.text, required this.fromUser, required this.dateTime});

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
