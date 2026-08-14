import 'dart:io';

import 'package:dio/dio.dart';

import '../core/api/api_exception.dart';
import '../models/github_user.dart';
import '../models/github_repo.dart';

class GithubApiService {
  final Dio _dio;

  GithubApiService(this._dio);

  Future<GithubUser> getUser(String username) async {
    try {
      final response = await _dio.get<Map<String, Object?>>('/users/$username');
      return GithubUser.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  Future<List<GithubRepo>> getRepos(String username) async {
    try {
      final response =
          await _dio.get<List<Object?>>('/users/$username/repos');
      final data = response.data!;
      return data
          .cast<Map<String, Object?>>()
          .map(GithubRepo.fromJson)
          .toList();
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  ApiException _mapException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          ApiFailure.timeout,
          'Request timed out',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          ApiFailure.network,
          'No internet connection',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return const ApiException(
            ApiFailure.notFound,
            'User not found',
          );
        }
        if (statusCode == 403) {
          return const ApiException(
            ApiFailure.rateLimited,
            'GitHub API rate limit hit, try later',
          );
        }
        return ApiException(
          ApiFailure.unknown,
          'Server error: $statusCode',
        );
      default:
        if (e.error is SocketException) {
          return const ApiException(
            ApiFailure.network,
            'No internet connection',
          );
        }
        return ApiException(
          ApiFailure.unknown,
          e.message ?? 'An unexpected error occurred',
        );
    }
  }
}
