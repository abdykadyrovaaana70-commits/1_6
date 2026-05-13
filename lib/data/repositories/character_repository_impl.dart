import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_api_service.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl(this._apiService);

  final CharacterApiService _apiService;

  @override
  Future<List<Character>> getCharacters() async {
    final model = await _apiService.getCharacters();
    return model.results.map((item) => item.toEntity()).toList();
  }

  @override
  Future<Character> getCharacterById(int id) async {
    final model = await _apiService.getCharacterById(id);
    return model.toEntity();
  }
}
