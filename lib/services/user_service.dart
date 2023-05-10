import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../Models/User/user_extended.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  Future createNewUser(String uid, String email) async {
    final user = UserExtended(uid: uid, email: email);
    return await userCollection.doc(user.uid).set(user.toJson());
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

  Future<UserExtended> getUserById(String uid) async {
    DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
    return UserExtended.fromJson(userSnapshot.data() as Map<String, dynamic>);
  }
}
