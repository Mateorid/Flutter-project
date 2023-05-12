import 'package:json_annotation/json_annotation.dart';
import 'package:pet_sitting/Models/review.dart';

part 'user_extended.g.dart';

@JsonSerializable() //todo make final
class UserExtended {
  final String uid;
  final String email;
  String? phoneNumber;
  String? name;
  String? location;
  String? aboutMe;
  String? imageUrl;
  List<String> pets = List.empty();
  List<Review> reviews = List.empty();

  UserExtended(
      {required this.uid,
      required this.email,
      this.phoneNumber,
      this.location,
      this.name,
      this.imageUrl,
      this.aboutMe});

  UserExtended copyWith(
      {String? email,
      String? phoneNumber,
      String? name,
      String? location,
      String? aboutMe,
      String? imageUrl}) {
    return UserExtended(
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        name: name ?? this.name,
        location: location ?? this.location,
        aboutMe: aboutMe ?? this.aboutMe,
        imageUrl: imageUrl ?? this.imageUrl,
        uid: uid);
  }

  factory UserExtended.fromJson(Map<String, dynamic> json) =>
      _$UserExtendedFromJson(json);

  Map<String, dynamic> toJson() => _$UserExtendedToJson(this);
}