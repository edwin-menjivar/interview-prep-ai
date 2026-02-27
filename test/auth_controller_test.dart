import 'package:flutter_test/flutter_test.dart';
import 'package:interview_cards_pro/src/features/auth/application/auth_controller.dart';
import 'package:interview_cards_pro/src/features/auth/data/session_store.dart';

class MemorySessionStore implements SessionStore {
  String? email;

  @override
  Future<void> clear() async {
    email = null;
  }

  @override
  Future<String?> loadSignedInEmail() async => email;

  @override
  Future<void> saveSignedInEmail(String email) async {
    this.email = email;
  }
}

void main() {
  test('invalid sign in returns signedOut with error', () async {
    final store = MemorySessionStore();
    final controller = AuthController(store);

    await controller.signIn(email: 'bad', password: '123');

    expect(controller.state.status, AuthStatus.signedOut);
    expect(controller.state.error, isNotNull);
  });

  test('valid sign in stores normalized email', () async {
    final store = MemorySessionStore();
    final controller = AuthController(store);

    await controller.signIn(email: 'USER@Example.com', password: 'secret1');

    expect(controller.state.status, AuthStatus.signedIn);
    expect(store.email, 'user@example.com');
  });
}
