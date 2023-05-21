import 'package:json_annotation/json_annotation.dart';
import 'package:pet_sitting/Models/review.dart';

part 'user_extended.g.dart';

@JsonSerializable()
class UserExtended {
  final String uid;
  final String email;
  final String? phoneNumber;
  final String? name;
  final String? location;
  final String? aboutMe;
  final String? imageUrl;
  final List<String> pets;
  final List<Review> reviews;

  UserExtended({
    required this.uid,
    required this.email,
    this.phoneNumber,
    this.location,
    this.name,
    this.imageUrl,
    this.aboutMe,
    this.pets = const [],
    this.reviews = const [],
  });

  UserExtended copyWith(
      {String? email,
      String? phoneNumber,
      String? name,
      String? location,
      String? aboutMe,
      String? imageUrl,
        List<Review>? reviews,
      }) {
    return UserExtended(
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        name: name ?? this.name,
        location: location ?? this.location,
        aboutMe: aboutMe ?? this.aboutMe,
        imageUrl: imageUrl ?? this.imageUrl,
        reviews: reviews ?? this.reviews,
        uid: uid);
  }

  double get averageReviewScore {
    if (reviews.isEmpty) {
      return 0.0; // or any default value you prefer
    }

    double totalScore = 0.0;
    for (var review in reviews) {
      totalScore += review.rating;
    }

    return totalScore / reviews.length;
  }

  factory UserExtended.fromJson(Map<String, dynamic> json) =>
      _$UserExtendedFromJson(json);

  Map<String, dynamic> toJson() => _$UserExtendedToJson(this);
}
