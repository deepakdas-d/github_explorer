import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/core/api/api_exception.dart';
import 'package:github_explorer/core/api/dio_client.dart';
import 'package:github_explorer/data/github_api_service.dart';

void main() {
  late GithubApiService service;

  setUp(() {
    service = GithubApiService(createDioClient());
  });

  test('getUser returns parsed GithubUser for octocat', () async {
    final user = await service.getUser('octocat');
    expect(user.login, 'octocat');
    expect(user.id, 583231);
    expect(user.avatarUrl, isNotEmpty);
  });

  test('getUser throws ApiFailure.notFound for nonexistent user', () async {
    try {
      await service.getUser('this-user-definitely-does-not-exist-zzz999');
      fail('Expected ApiException');
    } on ApiException catch (e) {
      expect(e.failure, ApiFailure.notFound);
    }
  });

  test('getRepos returns list for octocat', () async {
    final repos = await service.getRepos('octocat');
    expect(repos, isNotEmpty);
    expect(repos.first.name, isNotEmpty);
  });
}
