enum ApiFailure {
  notFound,
  network,
  timeout,
  rateLimited,
  unknown,
}

class ApiException implements Exception {
  final ApiFailure failure;
  final String message;

  const ApiException(this.failure, this.message);

  @override
  String toString() => 'ApiException($failure): $message';
}
