import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/models/github_user.dart';
import 'package:github_explorer/models/github_repo.dart';

void main() {
  group('GithubUser.fromJson', () {
    test('parses a real-shaped user JSON correctly', () {
      final json = <String, Object?>{
        'login': 'octocat',
        'id': 1,
        'avatar_url': 'https://avatars.githubusercontent.com/u/1?v=4',
        'name': 'The Octocat',
        'bio': 'GitHub mascot',
        'followers': 9000,
        'following': 9,
        'public_repos': 8,
        'html_url': 'https://github.com/octocat',
      };

      final user = GithubUser.fromJson(json);

      expect(user.login, 'octocat');
      expect(user.id, 1);
      expect(user.avatarUrl, 'https://avatars.githubusercontent.com/u/1?v=4');
      expect(user.name, 'The Octocat');
      expect(user.bio, 'GitHub mascot');
      expect(user.followers, 9000);
      expect(user.following, 9);
      expect(user.publicRepos, 8);
      expect(user.htmlUrl, 'https://github.com/octocat');
    });

    test('handles null name and bio', () {
      final json = <String, Object?>{
        'login': 'ghost',
        'id': 10137,
        'avatar_url': 'https://avatars.githubusercontent.com/u/10137?v=4',
        'name': null,
        'bio': null,
        'followers': 0,
        'following': 0,
        'public_repos': 0,
        'html_url': 'https://github.com/ghost',
      };

      final user = GithubUser.fromJson(json);

      expect(user.name, isNull);
      expect(user.bio, isNull);
    });
  });

  group('GithubRepo.fromJson', () {
    test('parses a real-shaped repo JSON correctly', () {
      final json = <String, Object?>{
        'id': 1296269,
        'name': 'Hello-World',
        'description': 'My first repository on GitHub!',
        'stargazers_count': 1500,
        'language': 'Dart',
        'updated_at': '2024-01-15T10:30:00Z',
        'html_url': 'https://github.com/octocat/Hello-World',
      };

      final repo = GithubRepo.fromJson(json);

      expect(repo.id, 1296269);
      expect(repo.name, 'Hello-World');
      expect(repo.description, 'My first repository on GitHub!');
      expect(repo.stargazersCount, 1500);
      expect(repo.language, 'Dart');
      expect(repo.updatedAt, DateTime.utc(2024, 1, 15, 10, 30));
      expect(repo.htmlUrl, 'https://github.com/octocat/Hello-World');
    });

    test('handles null description and language', () {
      final json = <String, Object?>{
        'id': 999,
        'name': 'empty-repo',
        'description': null,
        'stargazers_count': 0,
        'language': null,
        'updated_at': '2024-06-01T00:00:00Z',
        'html_url': 'https://github.com/octocat/empty-repo',
      };

      final repo = GithubRepo.fromJson(json);

      expect(repo.description, isNull);
      expect(repo.language, isNull);
    });
  });
}
