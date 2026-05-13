import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/quiz_question.dart';
import '../../domain/usecases/get_quiz_questions_usecase.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit(this._getQuizQuestionsUseCase) : super(QuizInitial());

  final GetQuizQuestionsUseCase _getQuizQuestionsUseCase;

  QuizGameConfig? _lastConfig;

  Future<void> loadQuiz({required QuizGameConfig config}) async {
    _lastConfig = config;
    emit(QuizLoading());

    try {
      final questions = await _getQuizQuestionsUseCase(
        amount: config.amount,
        categoryId: config.categoryId,
        difficulty: config.difficulty,
        type: config.type,
      );

      if (questions.isEmpty) {
        emit(const QuizError('Questions not found'));
        return;
      }

      emit(
        QuizLoaded(
          questions: questions,
          currentIndex: 0,
          score: 0,
          config: config,
        ),
      );
    } catch (error) {
      emit(QuizError(error.toString()));
    }
  }

  Future<void> selectAnswer(String answer) async {
    final currentState = state;

    if (currentState is! QuizLoaded || currentState.selectedAnswer != null) {
      return;
    }

    final currentQuestion = currentState.questions[currentState.currentIndex];
    final isCorrect = answer == currentQuestion.correctAnswer;
    final updatedScore = isCorrect
        ? currentState.score + 1
        : currentState.score;

    emit(currentState.copyWith(selectedAnswer: answer, score: updatedScore));

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (isClosed) {
      return;
    }

    final nextIndex = currentState.currentIndex + 1;

    if (nextIndex >= currentState.questions.length) {
      emit(
        QuizCompleted(
          questions: currentState.questions,
          score: updatedScore,
          config: currentState.config,
        ),
      );
      return;
    }

    emit(
      QuizLoaded(
        questions: currentState.questions,
        currentIndex: nextIndex,
        score: updatedScore,
        config: currentState.config,
      ),
    );
  }

  void skipQuestion() {
    final currentState = state;

    if (currentState is! QuizLoaded || currentState.selectedAnswer != null) {
      return;
    }

    final nextIndex = currentState.currentIndex + 1;

    if (nextIndex >= currentState.questions.length) {
      emit(
        QuizCompleted(
          questions: currentState.questions,
          score: currentState.score,
          config: currentState.config,
        ),
      );
      return;
    }

    emit(
      QuizLoaded(
        questions: currentState.questions,
        currentIndex: nextIndex,
        score: currentState.score,
        config: currentState.config,
      ),
    );
  }

  Future<void> restartQuiz() async {
    final config = _lastConfig;

    if (config == null) {
      return;
    }

    await loadQuiz(config: config);
  }
}
