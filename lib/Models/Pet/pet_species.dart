enum PetSpecies {
  dog('Dog'),
  cat('Cat'),
  bird('Bird'),
  reptile('Reptile'),
  smallMammal('Small mammal'),
  amphibian('Amphibian'),
  other('Other');

  final String text;
  const PetSpecies(this.text);
}
