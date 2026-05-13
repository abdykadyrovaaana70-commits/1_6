import '../entities/quiz_question.dart';
import '../repositories/quiz_repository.dart';

class GetQuizQuestionsUseCase {
  GetQuizQuestionsUseCase(this._repository);

  final QuizRepository _repository;

  Future<List<QuizQuestion>> call({
    required int amount,
    int? categoryId,
    String? difficulty,
    String? type,
  }) {
    return _repository.getQuizQuestions(
      amount: amount,
      categoryId: categoryId,
      difficulty: difficulty,
      type: type,
    );
  }
}
