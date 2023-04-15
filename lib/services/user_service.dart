import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/user.dart';

class UserService{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("Users");

  Future createNewUser(String uid, String email) async{
    return await userCollection.doc(uid).set({
      'name': "",
      'phone': "",
      'location': "",
      'email': email
    });
  }

  Future updateUser({required String id, String? email, String? phoneNumber, String? name, String? location}) async{
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
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    return UserExtended(
      uid: uid,
      email: userData['email'],
      phoneNumber: userData['phone'],
      name: userData['name'],
      location: userData['location'],
    );
  }


}