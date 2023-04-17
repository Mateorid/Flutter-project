import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/user_extended.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  Future createNewUser(String uid, String email) async {
    return await userCollection
        .doc(uid)
        .set({'name': "", 'phone': "", 'location': "", 'email': email});
  }

  Future updateUserX(UserExtended user) async {
    return await userCollection.doc(user.uid).set(user.toJson());
  }

  Future updateUser(
      {required String id,
      String? email,
      String? phoneNumber,
      String? name,
      String? location}) async {
    return await userCollection.doc(id).set({
      'name': name ?? "",
      'phone': phoneNumber ?? "",
      'location': location ?? "",
      'email': email ?? email
    });
  }

  Future<UserExtended?> getUserById(String uid) async {
    DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
    if (!userSnapshot.exists) {
      return null; // User with specified UID does not exist
    }
    return UserExtended.fromJson(userSnapshot.data() as Map<String, dynamic>);
  }
}
