class UserExtended {
  final String uid;
  final String email;
  String? phoneNumber;
  String? name;
  String? location;

  UserExtended(
      {required this.uid,
      required this.email,
      this.phoneNumber,
      this.location,
      this.name});

  UserExtended copyWith(
      {String? email, String? phoneNumber, String? name, String? location}) {
    return UserExtended(
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        name: name ?? this.name,
        location: location ?? this.location,
        uid: uid);
  }
}
