import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_clean_architecture/main.dart';

void main() {
  testWidgets('Quiz app opens start screen', (tester) async {
    await tester.pumpWidget(const QuizApp());

    expect(find.text('Quiz'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
  });
}
