import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';

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

  Future<String> createNewPet(Pet pet) async {
    return await _petCollection.add(pet).then((p) => p.id);
  }

  Future<void> deletePet(String petId) {
    return _petCollection.doc(petId).delete();
  }

  Future<Pet?> getPetById(String uid) async {
    final petSnapshot = await _petCollection.doc(uid).get();
    return petSnapshot.data();
  }

  Future<void> updatePet(String petId, Pet pet) async {
    await _petCollection.doc(petId).update(pet.toJson());
  }

  Stream<List<Pet>> get petStream =>
      _petCollection.snapshots().map((snapshot) =>
          snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());

  //TODO" COMBINE LATEST
  Stream<List<Pet>> petStreamFromIds(List<String> petIds) {
    return _petCollection.snapshots().map((snapshot) => snapshot.docs
        .map((docSnapshot) => docSnapshot.data())
        .where((element) => petIds.contains(element.id))
        .toList());
  }

  //todo does this make sense?
  Future<List<Pet>> getPetsByIds(List<String> petIds) async {
    final query = await _petCollection.get();
    return query.docs
        .map((e) => e.data())
        .where((p) => petIds.contains(p.id))
        .toList();
  }

  //todo delete these vvv
  Future<List<Pet>> getAllPets() async {
    final query = await _petCollection.get();
    return query.docs.map((e) => e.data()).toList();
  }
}
