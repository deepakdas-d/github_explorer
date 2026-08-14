class GithubRepo {
  final int id;
  final String name;
  final String? description;
  final int stargazersCount;
  final String? language;
  final DateTime updatedAt;
  final String htmlUrl;

  const GithubRepo({
    required this.id,
    required this.name,
    this.description,
    required this.stargazersCount,
    this.language,
    required this.updatedAt,
    required this.htmlUrl,
  });

  factory GithubRepo.fromJson(Map<String, Object?> json) {
    return GithubRepo(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      stargazersCount: json['stargazers_count'] as int,
      language: json['language'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      htmlUrl: json['html_url'] as String,
    );
  }
}
