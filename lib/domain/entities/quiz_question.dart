class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.category,
    required this.difficulty,
  });

  final String question;
  final List<String> answers;
  final String correctAnswer;
  final String category;
  final String difficulty;
}
