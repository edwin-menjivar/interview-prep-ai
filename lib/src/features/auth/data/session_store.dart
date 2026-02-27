import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SessionStore {
  Future<String?> loadSignedInEmail();
  Future<void> saveSignedInEmail(String email);
  Future<void> clear();
}

class SharedPrefsSessionStore implements SessionStore {
  static const _key = 'hiredeck.auth.email.v1';

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  @override
  Future<String?> loadSignedInEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  @override
  Future<void> saveSignedInEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, email.trim().toLowerCase());
  }
}
