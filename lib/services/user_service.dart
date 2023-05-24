import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';
import 'package:pet_sitting/services/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  final _userCollection =
      FirebaseFirestore.instance.collection("Users").withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return UserExtended.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

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

  Stream<UserExtended?> get currentUserStream {
    return _authService.authStateChanges.flatMap(
      (value) => getUserByIdStream(value!.uid),
    );
  }

  Future<UserExtended> getUserById(String uid) async {
    //todo change to stream
    final user = await _userCollection.doc(uid).get();
    return user.data()!;
  }

  Stream<UserExtended?> getUserByIdStream(String uid) {
    return _userCollection.doc(uid).snapshots().map((event) => event.data());
  }

  Future<void> createNewUser(String uid, String email) async {
    final user = UserExtended(uid: uid, email: email);
    return await _userCollection.doc(user.uid).set(user);
  }

  Future<void> updateUser(UserExtended user) async {
    return await _userCollection.doc(user.uid).set(user);
  }

  Future<void> addPetToCurrentUser(String petId) async {
    final userId = _authService.currentUserId;
    if (userId == null) {
      throw Exception('Couldn\'t get current user!');
    }
    return await _userCollection.doc(userId).update({
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
