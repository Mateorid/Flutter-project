import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/pet.dart';

class PetService{
  final CollectionReference petCollection = FirebaseFirestore.instance.collection("Pets");

  Future createNewPet(Pet pet) async{
    return await petCollection.add({
      'ownerId': pet.ownerId,
      'name': pet.name,
      'gender': pet.gender,
      'age': pet.age,
      'weight': pet.weight,
      'species': pet.species,
      'breed': pet.breed,
      'details': pet.details,
    });
  }
}