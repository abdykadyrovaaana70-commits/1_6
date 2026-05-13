import 'character_location.dart';

class Character {
  const Character({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
  });

  final int id;
  final String name;
  final String image;
  final String status;
  final String species;
  final String gender;
  final CharacterLocation origin;
  final CharacterLocation location;
}
