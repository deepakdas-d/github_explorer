import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/recent_searches_storage.dart';

final recentSearchesProvider =
    AsyncNotifierProvider<RecentSearchesNotifier, List<String>>(
  RecentSearchesNotifier.new,
);

class RecentSearchesNotifier extends AsyncNotifier<List<String>> {
  late RecentSearchesStorage _storage;

  @override
  FutureOr<List<String>> build() async {
    final prefs = await SharedPreferences.getInstance();
    _storage = RecentSearchesStorage(prefs);
    return _storage.load();
  }

  Future<void> addSearch(String username) async {
    final updated = await _storage.addSearch(username);
    state = AsyncData(updated);
  }
}
