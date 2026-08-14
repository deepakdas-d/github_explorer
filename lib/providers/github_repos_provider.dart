import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/github_repo.dart';
import 'github_api_service_provider.dart';

final githubReposProvider =
    FutureProvider.family<List<GithubRepo>, String>((ref, username) async {
  final service = ref.watch(githubApiServiceProvider);
  return service.getRepos(username);
});
