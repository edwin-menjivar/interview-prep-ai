import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract interface class BookmarkStore {
  Future<Set<String>> load();
  Future<void> save(Set<String> ids);
}

class SharedPrefsBookmarkStore implements BookmarkStore {
  static const _key = 'interview_cards.bookmarks.v1';

  @override
  Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return <String>{};
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return <String>{};
    }

    return decoded.whereType<String>().toSet();
  }

  @override
  Future<void> save(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(ids.toList()..sort()));
  }
}
