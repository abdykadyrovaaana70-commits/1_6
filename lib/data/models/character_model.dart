import '../../domain/entities/character.dart';
import '../../domain/entities/character_location.dart';

class CharacterModel {
  const CharacterModel({
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
  final CharacterLocationModel origin;
  final CharacterLocationModel location;

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      status: json['status'] as String? ?? '',
      species: json['species'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      origin: CharacterLocationModel.fromJson(
        json['origin'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      location: CharacterLocationModel.fromJson(
        json['location'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  Character toEntity() {
    return Character(
      id: id,
      name: name,
      image: image,
      status: status,
      species: species,
      gender: gender,
      origin: origin.toEntity(),
      location: location.toEntity(),
    );
  }
}

class CharacterLocationModel {
  const CharacterLocationModel({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  factory CharacterLocationModel.fromJson(Map<String, dynamic> json) {
    return CharacterLocationModel(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  CharacterLocation toEntity() {
    return CharacterLocation(
      name: name,
      url: url,
    );
  }
}
