import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RepoSort { stars, updated }

final repoSortProvider = StateProvider<RepoSort>((ref) {
  return RepoSort.stars;
});
