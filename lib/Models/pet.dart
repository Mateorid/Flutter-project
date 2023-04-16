class Pet{
  final String ownerId;
  final String name;
  final String gender;
  final String species;
  final String? age;
  final String? weight;
  final String? breed;
  final String? details;
  final String? uid;

  Pet({
    this.uid,
    required this.ownerId,
    required this.name,
    required this.gender,
    this.age,
    this.weight,
    required this.species,
    this.breed,
    this.details,
  });
}