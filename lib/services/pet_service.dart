import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Pet/pet.dart';

class PetService {
  final CollectionReference petCollection =
      FirebaseFirestore.instance.collection("Pets");

  Future createNewPet(Pet pet) async {
    String newKey = petCollection.doc().id;
    try {
      pet.id = newKey;
      await petCollection.doc(newKey).set(pet.toJson());
    } catch (e) {
      print('An exception occurred while creating a new pet: $e');
      rethrow;
    }
  }

  //todo update & delete

  Future<Pet?> getPetById(String uid) async {
    final petSnapshot = await petCollection.doc(uid).get();
    if (!petSnapshot.exists) {
      return null;
    }
    return Pet.fromJson(petSnapshot.data() as Map<String, dynamic>);
  }
}
