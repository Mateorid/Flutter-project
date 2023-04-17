import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/pet.dart';

class PetService{
  final CollectionReference petCollection = FirebaseFirestore.instance.collection("Pets");

  Future createNewPet(Pet pet) async {
    try {
      await petCollection.add(pet.toJson());
    } catch (e) {
      print('An exception occurred while creating a new pet: $e');
      rethrow;
    }
  }
}