import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/session_store.dart';
import 'auth_controller.dart';

final sessionStoreProvider = Provider<SessionStore>((ref) {
  return SharedPrefsSessionStore();
});

class AuthControllerNotifier extends StateNotifier<AuthState> {
  AuthControllerNotifier(this._controller)
      : super(const AuthState(status: AuthStatus.loading)) {
    initialize();
  }

  final AuthController _controller;

  Future<void> initialize() async {
    await _controller.initialize();
    state = _controller.state;
  }

  Future<void> signIn({required String email, required String password}) async {
    await _controller.signIn(email: email, password: password);
    state = _controller.state;
  }

  Future<void> signOut() async {
    await _controller.signOut();
    state = _controller.state;
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthControllerNotifier, AuthState>((ref) {
  final controller = AuthController(ref.watch(sessionStoreProvider));
  return AuthControllerNotifier(controller);
});
