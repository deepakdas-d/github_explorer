import 'package:flutter/material.dart';

import '../../../core/utils/date_utils.dart';
import '../../../models/github_repo.dart';

/// A fixed hash-to-color map for common programming languages.
const Map<String, Color> _languageColors = {
  'Dart': Color(0xFF00B4AB),
  'JavaScript': Color(0xFFF1E05A),
  'TypeScript': Color(0xFF3178C6),
  'Python': Color(0xFF3572A5),
  'Java': Color(0xFFB07219),
  'Kotlin': Color(0xFFA97BFF),
  'Swift': Color(0xFFFF5733),
  'C++': Color(0xFFF34B7D),
  'C#': Color(0xFF178600),
  'Go': Color(0xFF00ADD8),
  'Rust': Color(0xFFDEA584),
  'Ruby': Color(0xFF701516),
  'PHP': Color(0xFF4F5D95),
  'HTML': Color(0xFFE34C26),
  'CSS': Color(0xFF563D7C),
  'Shell': Color(0xFF89E051),
  'C': Color(0xFF555555),
  'Scala': Color(0xFFDC322F),
  'R': Color(0xFF198CE7),
  'Lua': Color(0xFF000080),
};

Color _getLanguageColor(String? language) {
  if (language == null) return const Color(0xFF9A9CA3);
  return _languageColors[language] ?? const Color(0xFF9A9CA3);
}

class RepoListItem extends StatelessWidget {
  final GithubRepo repo;

  const RepoListItem({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Repo name + language dot
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _getLanguageColor(repo.language),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        repo.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0A0A0A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Description
                Text(
                  repo.description ?? 'No description',
                  style: TextStyle(
                    fontSize: 13,
                    color: repo.description != null
                        ? const Color(0xFF0A0A0A)
                        : const Color(0xFF9A9CA3),
                    fontStyle: repo.description != null
                        ? FontStyle.normal
                        : FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Language + updated date
                Row(
                  children: [
                    Text(
                      repo.language ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9A9CA3),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      formatRelativeDate(repo.updatedAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9A9CA3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Star count
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                size: 16,
                color: Color(0xFFD7FF3D),
              ),
              const SizedBox(width: 3),
              Text(
                repo.stargazersCount.toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A0A0A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
