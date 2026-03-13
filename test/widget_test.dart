import 'package:flutter_test/flutter_test.dart';
import 'package:eight_puzzle_ai/main.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const PuzzleApp());
    expect(find.text('8 Puzzle Game'), findsOneWidget);
  });
}