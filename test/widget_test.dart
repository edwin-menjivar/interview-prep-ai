import 'package:flutter_test/flutter_test.dart';
import 'package:interview_cards_pro/main.dart' as app;

void main() {
  testWidgets('app boots without crashing', (tester) async {
    app.main();
    await tester.pump();
    expect(find.text('Interview Cards Pro'), findsOneWidget);
  });
}
