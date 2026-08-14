import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/github_user.dart';
import 'github_api_service_provider.dart';

final githubUserProvider =
    FutureProvider.family<GithubUser, String>((ref, username) async {
  final service = ref.watch(githubApiServiceProvider);
  return service.getUser(username);
});
