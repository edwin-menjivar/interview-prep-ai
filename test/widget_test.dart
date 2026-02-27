import 'package:flutter_test/flutter_test.dart';
import 'package:interview_cards_pro/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows sign in screen when logged out', (tester) async {
    SharedPreferences.setMockInitialValues({});

    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
