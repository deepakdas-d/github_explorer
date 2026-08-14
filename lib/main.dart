import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/search/search_screen.dart';

void main() {
  runApp(const ProviderScope(child: GithubExplorerApp()));
}

class GithubExplorerApp extends StatelessWidget {
  const GithubExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.light(
      surface: const Color(0xFFF3F4F6),
      primary: const Color(0xFFD7FF3D),
      onPrimary: const Color(0xFF0A0A0A),
      secondary: const Color(0xFF0E0E10),
      onSecondary: Colors.white,
      error: const Color(0xFFF0483E),
    );

    return MaterialApp(
      title: 'GitHub Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        cardColor: Colors.white,
        fontFamily: 'Inter',
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.secondary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: colorScheme.primary,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
        splashColor: colorScheme.primary.withValues(alpha: 0.1),
        highlightColor: colorScheme.primary.withValues(alpha: 0.05),
      ),
      home: const SearchScreen(),
    );
  }
}
