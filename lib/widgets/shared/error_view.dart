import 'package:flutter/material.dart';

import '../../core/api/api_exception.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, message, showRetry) = _resolveError(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56,
              color: const Color(0xFFF0483E),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0A0A0A),
              ),
            ),
            if (showRetry && onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD7FF3D),
                  foregroundColor: const Color(0xFF0A0A0A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  (IconData, String, bool) _resolveError(Object error) {
    if (error is ApiException) {
      switch (error.failure) {
        case ApiFailure.notFound:
          return (Icons.person_off_outlined, 'User not found', false);
        case ApiFailure.network:
          return (
            Icons.wifi_off_rounded,
            'No internet connection',
            true,
          );
        case ApiFailure.timeout:
          return (
            Icons.timer_off_outlined,
            'Request timed out',
            true,
          );
        case ApiFailure.rateLimited:
          return (
            Icons.block_outlined,
            'GitHub API rate limit hit, try later',
            false,
          );
        case ApiFailure.unknown:
          return (
            Icons.error_outline,
            error.message,
            true,
          );
      }
    }
    return (Icons.error_outline, 'An unexpected error occurred', true);
  }
}
