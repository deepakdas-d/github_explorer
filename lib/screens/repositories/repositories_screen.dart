import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/github_repo.dart';
import '../../providers/github_repos_provider.dart';
import '../../providers/repo_sort_provider.dart';
import '../../widgets/shared/loading_view.dart';
import '../../widgets/shared/error_view.dart';
import 'widgets/repo_list_item.dart';
import 'widgets/sort_toggle.dart';

class RepositoriesScreen extends ConsumerWidget {
  final String username;

  const RepositoriesScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reposAsync = ref.watch(githubReposProvider(username));
    final sortMode = ref.watch(repoSortProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Column(
        children: [
          // Dark header bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              bottom: 16,
              left: 8,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF0E0E10),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    username,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: reposAsync.when(
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(
                error: error,
                onRetry: () =>
                    ref.invalidate(githubReposProvider(username)),
              ),
              data: (repos) {
                if (repos.isEmpty) {
                  return const _EmptyReposView();
                }

                final sortedRepos = _sortRepos(repos, sortMode);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${repos.length} repositories',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9A9CA3),
                            ),
                          ),
                          const SortToggle(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        itemCount: sortedRepos.length,
                        itemBuilder: (_, index) => RepoListItem(
                          repo: sortedRepos[index],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<GithubRepo> _sortRepos(List<GithubRepo> repos, RepoSort sort) {
    final sorted = List<GithubRepo>.from(repos);
    switch (sort) {
      case RepoSort.stars:
        sorted.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
      case RepoSort.updated:
        sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    return sorted;
  }
}

class _EmptyReposView extends StatelessWidget {
  const _EmptyReposView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 56,
            color: Color(0xFF9A9CA3),
          ),
          SizedBox(height: 14),
          Text(
            'No public repositories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9A9CA3),
            ),
          ),
        ],
      ),
    );
  }
}
