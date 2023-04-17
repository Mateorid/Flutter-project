import 'package:json_annotation/json_annotation.dart';
import 'package:pet_sitting/Models/user_type.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final int rating; //0-5 *
  final String text;
  final String fromUser;
  final UserType userType;

  Review(this.rating, this.text, this.fromUser, this.userType);

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
