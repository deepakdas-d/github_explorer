class GithubUser {
  final String login;
  final int id;
  final String avatarUrl;
  final String? name;
  final String? bio;
  final int followers;
  final int following;
  final int publicRepos;
  final String htmlUrl;

  const GithubUser({
    required this.login,
    required this.id,
    required this.avatarUrl,
    this.name,
    this.bio,
    required this.followers,
    required this.following,
    required this.publicRepos,
    required this.htmlUrl,
  });

  factory GithubUser.fromJson(Map<String, Object?> json) {
    return GithubUser(
      login: json['login'] as String,
      id: json['id'] as int,
      avatarUrl: json['avatar_url'] as String,
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      followers: json['followers'] as int,
      following: json['following'] as int,
      publicRepos: json['public_repos'] as int,
      htmlUrl: json['html_url'] as String,
    );
  }
}
