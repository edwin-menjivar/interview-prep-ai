import '../data/session_store.dart';

enum AuthStatus { loading, signedOut, signedIn }

class AuthState {
  const AuthState({
    required this.status,
    this.email,
    this.error,
  });

  final AuthStatus status;
  final String? email;
  final String? error;

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      error: error,
    );
  }
}

class AuthController {
  AuthController(this._sessionStore)
      : state = const AuthState(status: AuthStatus.loading);

  final SessionStore _sessionStore;
  AuthState state;

  Future<void> initialize() async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    final email = await _sessionStore.loadSignedInEmail();
    if (email == null || email.isEmpty) {
      state = const AuthState(status: AuthStatus.signedOut);
      return;
    }
    state = AuthState(status: AuthStatus.signedIn, email: email);
  }

  Future<void> signIn({required String email, required String password}) async {
    final normalized = email.trim().toLowerCase();
    if (!normalized.contains('@')) {
      state = const AuthState(
        status: AuthStatus.signedOut,
        error: 'Enter a valid email.',
      );
      return;
    }
    if (password.length < 6) {
      state = const AuthState(
        status: AuthStatus.signedOut,
        error: 'Password must be at least 6 characters.',
      );
      return;
    }

    await _sessionStore.saveSignedInEmail(normalized);
    state = AuthState(status: AuthStatus.signedIn, email: normalized);
  }

  Future<void> signOut() async {
    await _sessionStore.clear();
    state = const AuthState(status: AuthStatus.signedOut);
  }
}
