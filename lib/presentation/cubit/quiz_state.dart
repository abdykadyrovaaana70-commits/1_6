part of 'quiz_cubit.dart';

class QuizGameConfig {
  const QuizGameConfig({
    required this.amount,
    this.categoryId,
    this.categoryName = 'Mixed',
    this.difficulty,
    this.type,
  });

  final int amount;
  final int? categoryId;
  final String categoryName;
  final String? difficulty;
  final String? type;

  String get difficultyLabel => difficulty == null
      ? 'All'
      : difficulty![0].toUpperCase() + difficulty!.substring(1);

  String get typeLabel {
    if (type == null) {
      return 'All';
    }

    return type == 'boolean' ? 'True / False' : 'Multiple Choice';
  }
}

abstract class QuizState {
  const QuizState();
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  const QuizLoaded({
    required this.questions,
    required this.currentIndex,
    required this.score,
    required this.config,
    this.selectedAnswer,
  });

  final List<QuizQuestion> questions;
  final int currentIndex;
  final int score;
  final QuizGameConfig config;
  final String? selectedAnswer;

  QuizQuestion get currentQuestion => questions[currentIndex];

  QuizLoaded copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? score,
    QuizGameConfig? config,
    String? selectedAnswer,
  }) {
    return QuizLoaded(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      config: config ?? this.config,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    );
  }
}

class QuizCompleted extends QuizState {
  const QuizCompleted({
    required this.questions,
    required this.score,
    required this.config,
  });

  final List<QuizQuestion> questions;
  final int score;
  final QuizGameConfig config;
}

class QuizError extends QuizState {
  const QuizError(this.message);

  final String message;
}
