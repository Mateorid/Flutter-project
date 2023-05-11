import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_sitting/ioc_container.dart';
import 'package:pet_sitting/services/auth_service.dart';

import '../Models/User/user_extended.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  final authService = get<AuthService>();

  Future<void> createNewUser(String uid, String email) async {
    final user = UserExtended(uid: uid, email: email);
    return await userCollection.doc(user.uid).set(user.toJson());
  }

  Future<void> updateUserX(UserExtended user) async {
    return await userCollection.doc(user.uid).set(user.toJson());
  }

  Future<void> updateUser(
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

  Future<void> addPetToCurrentUser(String petId) async {
    final userId = authService.currentUser?.uid;
    if (userId == null) {
      throw Exception('Couldn\'t get current user!');
    }
    return await userCollection.doc(userId).update({
      'pets': FieldValue.arrayUnion([petId]),
    });
  }

  Future<UserExtended> getUserById(String uid) async {
    DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
    return UserExtended.fromJson(userSnapshot.data() as Map<String, dynamic>);
  }
}
