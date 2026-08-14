String formatRelativeDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 365) {
    final years = (difference.inDays / 365).floor();
    return 'Updated ${years == 1 ? '1 year' : '$years years'} ago';
  }
  if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return 'Updated ${months == 1 ? '1 month' : '$months months'} ago';
  }
  if (difference.inDays > 0) {
    return 'Updated ${difference.inDays == 1 ? '1 day' : '${difference.inDays} days'} ago';
  }
  if (difference.inHours > 0) {
    return 'Updated ${difference.inHours == 1 ? '1 hour' : '${difference.inHours} hours'} ago';
  }
  if (difference.inMinutes > 0) {
    return 'Updated ${difference.inMinutes == 1 ? '1 minute' : '${difference.inMinutes} minutes'} ago';
  }
  return 'Updated just now';
}
