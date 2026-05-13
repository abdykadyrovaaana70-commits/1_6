import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/di/inject_module.dart';
import '../cubit/quiz_cubit.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const _categories = <_QuizCategory>[
    _QuizCategory(null, 'All'),
    _QuizCategory(9, 'General Knowledge'),
    _QuizCategory(10, 'Entertainment: Books'),
    _QuizCategory(11, 'Entertainment: Film'),
    _QuizCategory(12, 'Entertainment: Music'),
    _QuizCategory(14, 'Entertainment: Television'),
    _QuizCategory(15, 'Entertainment: Video Games'),
    _QuizCategory(17, 'Science & Nature'),
    _QuizCategory(18, 'Science: Computers'),
    _QuizCategory(20, 'Mythology'),
    _QuizCategory(21, 'Sports'),
    _QuizCategory(22, 'Geography'),
    _QuizCategory(23, 'History'),
    _QuizCategory(24, 'Politics'),
    _QuizCategory(25, 'Art'),
    _QuizCategory(27, 'Animals'),
    _QuizCategory(28, 'Vehicles'),
  ];

  int _amount = 10;
  _QuizCategory _category = _categories.first;
  String? _difficulty;
  String? _type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Quiz',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 36),
                  const _QuizGem(),
                  const SizedBox(height: 34),
                  _AmountSlider(
                    amount: _amount,
                    onChanged: (value) {
                      setState(() => _amount = value.round());
                    },
                  ),
                  const SizedBox(height: 18),
                  _SelectField<_QuizCategory>(
                    label: 'Category',
                    value: _category,
                    items: _categories,
                    getLabel: (item) => item.name,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _category = value);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  _SelectField<String?>(
                    label: 'Difficulty',
                    value: _difficulty,
                    items: const [null, 'easy', 'medium', 'hard'],
                    getLabel: (item) {
                      if (item == null) {
                        return 'All';
                      }

                      return item[0].toUpperCase() + item.substring(1);
                    },
                    onChanged: (value) => setState(() => _difficulty = value),
                  ),
                  const SizedBox(height: 14),
                  _SelectField<String?>(
                    label: 'Type',
                    value: _type,
                    items: const [null, 'multiple', 'boolean'],
                    getLabel: (item) {
                      if (item == null) {
                        return 'All';
                      }

                      return item == 'boolean'
                          ? 'True / False'
                          : 'Multiple Choice';
                    },
                    onChanged: (value) => setState(() => _type = value),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 54,
                    child: FilledButton(
                      onPressed: _startQuiz,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF6975FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'START',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const _BottomNavigation(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startQuiz() {
    final config = QuizGameConfig(
      amount: _amount,
      categoryId: _category.id,
      categoryName: _category.id == null ? 'Mixed' : _category.name,
      difficulty: _difficulty,
      type: _type,
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => QuizGameScreen(config: config)),
    );
  }
}

class QuizGameScreen extends StatelessWidget {
  const QuizGameScreen({required this.config, super.key});

  final QuizGameConfig config;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QuizCubit>()..loadQuiz(config: config),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<QuizCubit, QuizState>(
            builder: (context, state) {
              if (state is QuizInitial || state is QuizLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFC04CFF)),
                );
              }

              if (state is QuizError) {
                return _QuizErrorView(
                  message: state.message,
                  onRetry: () {
                    context.read<QuizCubit>().loadQuiz(config: config);
                  },
                );
              }

              if (state is QuizCompleted) {
                return _QuizResultView(state: state);
              }

              return _QuizQuestionView(state: state as QuizLoaded);
            },
          ),
        ),
      ),
    );
  }
}

class _QuizQuestionView extends StatelessWidget {
  const _QuizQuestionView({required this.state});

  final QuizLoaded state;

  @override
  Widget build(BuildContext context) {
    final question = state.currentQuestion;
    final progress = (state.currentIndex + 1) / state.questions.length;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Expanded(
                    child: Text(
                      question.category,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: const Color(0xFFE6E6EA),
                  color: const Color(0xFFC04CFF),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${state.currentIndex + 1}/${state.questions.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8D8D98),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 34),
              Text(
                question.question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              ...question.answers.map(
                (answer) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AnswerButton(
                    answer: answer,
                    selectedAnswer: state.selectedAnswer,
                    correctAnswer: question.correctAnswer,
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 86,
                  height: 42,
                  child: FilledButton(
                    onPressed: state.selectedAnswer == null
                        ? context.read<QuizCubit>().skipQuestion
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5D86),
                      disabledBackgroundColor: const Color(0xFFFFB8C8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    child: const Text('Skip', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.answer,
    required this.selectedAnswer,
    required this.correctAnswer,
  });

  final String answer;
  final String? selectedAnswer;
  final String correctAnswer;

  @override
  Widget build(BuildContext context) {
    final isAnswered = selectedAnswer != null;
    final isHighlighted = answer == correctAnswer || answer == selectedAnswer;
    final backgroundColor = isHighlighted ? _highlightColor : Colors.white;
    final textColor = isAnswered && isHighlighted
        ? Colors.white
        : const Color(0xFF6975FF);

    return SizedBox(
      height: 43,
      child: OutlinedButton(
        onPressed: selectedAnswer == null
            ? () => context.read<QuizCubit>().selectAnswer(answer)
            : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledForegroundColor: textColor,
          side: BorderSide(
            color: isHighlighted ? backgroundColor : const Color(0xFF6975FF),
            width: 1.3,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(
          answer,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Color get _highlightColor {
    if (answer == correctAnswer) {
      return const Color(0xFF51D8A5);
    }

    return const Color(0xFFFF4E4E);
  }
}

class _QuizResultView extends StatelessWidget {
  const _QuizResultView({required this.state});

  final QuizCompleted state;

  @override
  Widget build(BuildContext context) {
    final percent = state.questions.isEmpty
        ? 0
        : ((state.score / state.questions.length) * 100).round();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Result',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 44),
              const Icon(
                Icons.check_rounded,
                size: 96,
                color: Color(0xFF51D8A5),
              ),
              const SizedBox(height: 56),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 24,
                      offset: Offset(0, 9),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Category: ${state.config.categoryName}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: _ResultMetric(
                            label: 'Difficulty',
                            value: state.config.difficultyLabel,
                          ),
                        ),
                        Expanded(
                          child: _ResultMetric(
                            label: 'Correct answers',
                            value: '${state.score}/${state.questions.length}',
                          ),
                        ),
                        Expanded(
                          child: _ResultMetric(
                            label: 'Result',
                            value: '$percent%',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 94,
                  height: 42,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF51D8A5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    child: const Text('Finish', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizErrorView extends StatelessWidget {
  const _QuizErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 18),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _AmountSlider extends StatelessWidget {
  const _AmountSlider({required this.amount, required this.onChanged});

  final int amount;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: 'Questions amount: ',
            style: const TextStyle(
              color: Color(0xFFB2B2BC),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: '$amount',
                style: const TextStyle(
                  color: Color(0xFF4D4D58),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: const Color(0xFFC04CFF),
            inactiveTrackColor: const Color(0xFFE7E7EC),
            thumbColor: const Color(0xFFC04CFF),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            value: amount.toDouble(),
            min: 5,
            max: 30,
            divisions: 25,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _SelectField<T> extends StatelessWidget {
  const _SelectField({
    required this.label,
    required this.value,
    required this.items,
    required this.getLabel,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T item) getLabel;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB2B2BC),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F7FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    getLabel(item),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _QuizGem extends StatelessWidget {
  const _QuizGem();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF3E7FF),
            ),
          ),
          const Icon(Icons.quiz_rounded, color: Color(0xFFC04CFF), size: 38),
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(Icons.explore_outlined, color: Color(0xFFC04CFF), size: 22),
        Icon(Icons.history_rounded, color: Color(0xFFD4D4DC), size: 22),
        Icon(Icons.person_outline_rounded, color: Color(0xFFD4D4DC), size: 22),
      ],
    );
  }
}

class _ResultMetric extends StatelessWidget {
  const _ResultMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFB2B2BC),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF50505B),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _QuizCategory {
  const _QuizCategory(this.id, this.name);

  final int? id;
  final String name;
}
