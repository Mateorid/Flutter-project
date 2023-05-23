import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';
import 'package:pet_sitting/services/auth_service.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");
  final AuthService _authService;

  UserService(this._authService);

  String? get currentUserId => _authService.currentUserId;

  Future<UserExtended?> get currentUser async {
    final id = currentUserId;
    if (id == null) {
      return null;
    }
    return getUserById(id);
  }

  Future<UserExtended> getUserById(String uid) async {
    //todo change to stream
    DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
    return UserExtended.fromJson(userSnapshot.data() as Map<String, dynamic>);
  }

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
    final userId = _authService.currentUserId;
    if (userId == null) {
      throw Exception('Couldn\'t get current user!');
    }
    return await userCollection.doc(userId).update({
      'pets': FieldValue.arrayUnion([petId]),
    });
  }

  Future<bool> currentUserIsOwnerOfPet(String petId) async {
    final user = await currentUser;
    if (user == null) {
      throw Exception('Couldn\'t get current user!');
    }
    return user.pets.contains(petId);
  }
}
