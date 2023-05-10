import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Pet/pet.dart';

class PetService {
  final CollectionReference _petCollection =
      FirebaseFirestore.instance.collection("Pets");

  //todo with converter

  Future<void> createNewPet(Pet pet) async {
    String newKey = _petCollection.doc().id;
    try {
      pet.id = newKey;
      await _petCollection.doc(newKey).set(pet.toJson());
    } catch (e) {
      print('An exception occurred while creating a new pet: $e');
      rethrow;
    }
  }

  //todo update & delete

  Future<Pet?> getPetById(String uid) async {
    final petSnapshot = await _petCollection.doc(uid).get();
    if (!petSnapshot.exists) {
      return null;
    }
    return _petFromData(petSnapshot.data());
  }

  Future<List<Pet>> getAllPets() async {
    final query = await _petCollection.get();
    return query.docs.map((e) => _petFromData(e.data())).toList();
  }

  Pet _petFromData(Object? input) {
    return Pet.fromJson(input as Map<String, dynamic>);
  }
}
