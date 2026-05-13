import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/app_exception.dart';
import '../models/quiz_api_response_model.dart';

class QuizApiService {
  QuizApiService(this._dio);

  final Dio _dio;

  Future<QuizApiResponseModel> getQuizQuestions({
    required int amount,
    int? categoryId,
    String? difficulty,
    String? type,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'amount': amount,
        'encode': 'url3986',
      };

      if (categoryId != null) {
        queryParameters['category'] = categoryId;
      }

      if (difficulty != null) {
        queryParameters['difficulty'] = difficulty;
      }

      if (type != null) {
        queryParameters['type'] = type;
      }

      final response = await _dio.get(
        ApiConstants.quizPath,
        queryParameters: queryParameters,
      );

      final model = QuizApiResponseModel.fromJson(
        response.data as Map<String, dynamic>? ?? <String, dynamic>{},
      );

      if (model.responseCode != 0) {
        throw AppException(
          'OpenTDB returned response_code: ${model.responseCode}',
        );
      }

      if (model.results.isEmpty) {
        throw AppException('No quiz questions were returned');
      }

      return model;
    } on DioException catch (error) {
      throw AppException(error.message ?? 'Failed to load quiz questions');
    } on AppException {
      rethrow;
    } catch (_) {
      throw AppException('Unexpected error while loading quiz questions');
    }
  }
}
