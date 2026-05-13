import '../../domain/entities/quiz_question.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_api_service.dart';

class QuizRepositoryImpl implements QuizRepository {
  QuizRepositoryImpl(this._apiService);

  final QuizApiService _apiService;

  @override
  Future<List<QuizQuestion>> getQuizQuestions({
    required int amount,
    int? categoryId,
    String? difficulty,
    String? type,
  }) async {
    final model = await _apiService.getQuizQuestions(
      amount: amount,
      categoryId: categoryId,
      difficulty: difficulty,
      type: type,
    );
    return model.results.map((item) => item.toEntity()).toList();
  }
}
