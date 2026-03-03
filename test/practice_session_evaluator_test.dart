import 'package:flutter_test/flutter_test.dart';
import 'package:interview_cards_pro/src/features/interview_cards/application/practice_session_evaluator.dart';

void main() {
  test('calculates summary counts and confidence percent', () {
    final score = PracticeSessionEvaluator.calculate([3, 2, 1, 3, null]);

    expect(score.total, 5);
    expect(score.strong, 2);
    expect(score.solid, 1);
    expect(score.needsWork, 1);
    expect(score.completionPercent, 80);
    expect(score.confidencePercent, 61);
  });

  test('returns zero percentages when there are no cards', () {
    final score = PracticeSessionEvaluator.calculate([]);

    expect(score.completionPercent, 0);
    expect(score.confidencePercent, 0);
  });
}
