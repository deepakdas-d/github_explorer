import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/github_user_provider.dart';
import '../../providers/recent_searches_provider.dart';
import '../../widgets/shared/loading_view.dart';
import '../../widgets/shared/error_view.dart';
import '../repositories/repositories_screen.dart';
import 'widgets/recent_search_chips.dart';
import 'widgets/user_profile_card.dart';

final searchedUsernameProvider = StateProvider<String?>((ref) => null);

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch([String? prefilled]) {
    final username = prefilled ?? _controller.text.trim();
    if (username.isEmpty) return;

    if (prefilled != null) {
      _controller.text = username;
    }

    ref.read(searchedUsernameProvider.notifier).state = username;
    // Invalidate to force a new fetch even if same username searched again
    ref.invalidate(githubUserProvider);
  }

  @override
  Widget build(BuildContext context) {
    final searchedUsername = ref.watch(searchedUsernameProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'GitHub Explorer',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0A0A0A),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Search for any GitHub user',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9A9CA3),
                ),
              ),
              const SizedBox(height: 20),
              // Search field — white pill with shadow
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _submitSearch(),
                  decoration: InputDecoration(
                    hintText: 'Enter GitHub username',
                    hintStyle: const TextStyle(
                      color: Color(0xFF9A9CA3),
                      fontSize: 15,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF9A9CA3),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFF0A0A0A),
                      ),
                      onPressed: _submitSearch,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              RecentSearchChips(
                onTap: (username) => _submitSearch(username),
              ),
              const SizedBox(height: 16),
              // Results area
              Expanded(
                child: searchedUsername == null
                    ? const _IdleView()
                    : _UserResultView(
                        username: searchedUsername,
                        onViewRepos: (username) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => RepositoriesScreen(
                                username: username,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Search for a GitHub user to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserResultView extends ConsumerWidget {
  final String username;
  final void Function(String username) onViewRepos;

  const _UserResultView({
    required this.username,
    required this.onViewRepos,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(githubUserProvider(username));

    return userAsync.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(githubUserProvider),
      ),
      data: (user) {
        // Save to recent searches on successful fetch
        ref.read(recentSearchesProvider.notifier).addSearch(user.login);
        return SingleChildScrollView(
          child: UserProfileCard(
            user: user,
            onViewRepos: () => onViewRepos(user.login),
          ),
        );
      },
    );
  }
}
