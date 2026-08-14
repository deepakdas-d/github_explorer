import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/github_user_provider.dart';
import '../../providers/recent_searches_provider.dart';
import '../search/widgets/user_profile_card.dart';
import '../repositories/repositories_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentSearchesAsync = ref.watch(recentSearchesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E10),
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text(
          'Recent Searches',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: recentSearchesAsync.when(
        data: (searches) {
          if (searches.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Color(0xFF9A9CA3),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No recent searches',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9A9CA3),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: searches.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final username = searches[index];
              return Consumer(
                builder: (context, ref, _) {
                  final userAsync = ref.watch(githubUserProvider(username));

                  return userAsync.when(
                    data: (user) => GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RepositoriesScreen(username: username),
                        ),
                      ),
                      child: UserProfileCard(
                        user: user,
                        onViewRepos: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RepositoriesScreen(username: username),
                          ),
                        ),
                      ),
                    ),
                    loading: () => Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFD7FF3D),
                        ),
                      ),
                    ),
                    error: (error, _) => ListTile(
                      tileColor: Colors.red.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      leading: const Icon(Icons.error_outline, color: Colors.red),
                      title: Text(username),
                      subtitle: const Text('Failed to load profile'),
                      onTap: () => Navigator.of(context).pop(username),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFD7FF3D)),
        ),
        error: (error, _) => Center(
          child: Text(
            'Error loading history',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }
}

