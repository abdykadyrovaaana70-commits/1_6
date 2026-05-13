import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetCharacterByIdUseCase {
  GetCharacterByIdUseCase(this._repository);

  final CharacterRepository _repository;

  Future<Character> call(int id) {
    return _repository.getCharacterById(id);
  }
}
