import '../entities/quiz_question.dart';

abstract class QuizRepository {
  Future<List<QuizQuestion>> getQuizQuestions({
    required int amount,
    int? categoryId,
    String? difficulty,
    String? type,
  });
}
