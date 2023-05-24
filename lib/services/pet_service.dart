import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

class PetService {
  final _petCollection =
      FirebaseFirestore.instance.collection("Pets").withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return Pet.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );
  final UserService _userService;

  PetService(this._userService);

  Future<String> createNewPet(Pet pet) async {
    return await _petCollection.add(pet).then((p) => p.id);
  }

  Stream<Pet?> getPetById(String id) {
    return _petCollection.doc(id).snapshots().map((event) => event.data());
  }

  Future<void> updatePet(String petId, Pet pet) {
    return _petCollection.doc(petId).set(pet);
  }

  Future<void> deletePet(String petId) {
    return _petCollection.doc(petId).delete();
  }

  Stream<List<Pet>> get petStream => _petCollection
      .snapshots()
      .map((qs) => qs.docs.map((ds) => ds.data()).toList());

  Stream<List<Pet>> get currentUserPetStream => _userService.currentUserStream
      .flatMap((value) => petStreamFromIds(value!.pets));

  Stream<List<Pet>> petStreamFromIds(List<String> petIds) {
    return _petCollection.snapshots().map((snapshot) => snapshot.docs
        .map((docSnapshot) => docSnapshot.data())
        .where((element) => petIds.contains(element.id))
        .toList());
  }
}
