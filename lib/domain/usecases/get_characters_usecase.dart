import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetCharactersUseCase {
  GetCharactersUseCase(this._repository);

  final CharacterRepository _repository;

  Future<List<Character>> call() {
    return _repository.getCharacters();
  }
}
