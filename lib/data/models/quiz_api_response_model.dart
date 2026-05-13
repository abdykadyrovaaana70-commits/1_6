import 'dart:math';

import '../../domain/entities/quiz_question.dart';

class QuizApiResponseModel {
  const QuizApiResponseModel({
    required this.responseCode,
    required this.results,
  });

  final int responseCode;
  final List<QuizQuestionModel> results;

  factory QuizApiResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'] as List<dynamic>? ?? <dynamic>[];

    return QuizApiResponseModel(
      responseCode: json['response_code'] as int? ?? -1,
      results: rawResults
          .map(
            (item) => QuizQuestionModel.fromJson(
              item as Map<String, dynamic>? ?? <String, dynamic>{},
            ),
          )
          .toList(),
    );
  }
}

class QuizQuestionModel {
  const QuizQuestionModel({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawIncorrectAnswers =
        json['incorrect_answers'] as List<dynamic>? ?? <dynamic>[];

    return QuizQuestionModel(
      category: Uri.decodeComponent(json['category'] as String? ?? ''),
      type: json['type'] as String? ?? '',
      difficulty: Uri.decodeComponent(json['difficulty'] as String? ?? ''),
      question: Uri.decodeComponent(json['question'] as String? ?? ''),
      correctAnswer: Uri.decodeComponent(
        json['correct_answer'] as String? ?? '',
      ),
      incorrectAnswers: rawIncorrectAnswers
          .map((item) => Uri.decodeComponent(item as String? ?? ''))
          .toList(),
    );
  }

  QuizQuestion toEntity() {
    final answers = <String>[
      ...incorrectAnswers,
      correctAnswer,
    ]..shuffle(Random());

    return QuizQuestion(
      question: question,
      answers: answers,
      correctAnswer: correctAnswer,
      category: category,
      difficulty: difficulty,
    );
  }
}
