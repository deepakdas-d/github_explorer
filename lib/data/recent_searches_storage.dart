import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchesStorage {
  static const _key = 'recent_searches';
  static const _maxItems = 5;

  final SharedPreferences _prefs;

  RecentSearchesStorage(this._prefs);

  List<String> load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw);
    return (decoded as List<Object?>).cast<String>();
  }

  Future<void> save(List<String> searches) async {
    await _prefs.setString(_key, jsonEncode(searches));
  }

  Future<List<String>> addSearch(String username) async {
    final current = load();
    // Remove if already present (dedupe), then push to front
    current.remove(username);
    current.insert(0, username);
    // Truncate to max
    final trimmed =
        current.length > _maxItems ? current.sublist(0, _maxItems) : current;
    await save(trimmed);
    return trimmed;
  }
}
