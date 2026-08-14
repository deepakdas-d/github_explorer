import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/github_api_service.dart';
import 'dio_provider.dart';

final githubApiServiceProvider = Provider<GithubApiService>((ref) {
  return GithubApiService(ref.watch(dioProvider));
});
