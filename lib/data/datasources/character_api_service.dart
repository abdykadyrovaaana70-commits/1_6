import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/app_exception.dart';
import '../models/character_list_model.dart';
import '../models/character_model.dart';

class CharacterApiService {
  CharacterApiService(this._dio);

  final Dio _dio;

  Future<CharacterListModel> getCharacters() async {
    try {
      final response = await _dio.get(ApiConstants.charactersPath);
      return CharacterListModel.fromJson(
        response.data as Map<String, dynamic>? ?? <String, dynamic>{},
      );
    } on DioException catch (error) {
      throw AppException(
        error.message ?? 'Failed to load Rick and Morty characters',
      );
    } catch (_) {
      throw AppException('Unexpected error while loading characters');
    }
  }

  Future<CharacterModel> getCharacterById(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.charactersPath}/$id');
      return CharacterModel.fromJson(
        response.data as Map<String, dynamic>? ?? <String, dynamic>{},
      );
    } on DioException catch (error) {
      throw AppException(
        error.message ?? 'Failed to load character details',
      );
    } catch (_) {
      throw AppException('Unexpected error while loading character details');
    }
  }
}
