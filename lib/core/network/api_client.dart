import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/foundation.dart';

import '../error/failure.dart';

/// Converts transport errors at the data boundary; callers never receive Dio errors.
Future<Either<Failure, T>> request<T>(Future<T> Function() operation) async {
  try {
    return right(await operation());
  } on DioException catch (error) {
    if (error.response != null) {
      return left(
        ServerFailure(
          'Server request failed',
          statusCode: error.response?.statusCode,
        ),
      );
    }
    return left(const NetworkFailure('Network request failed'));
  } catch (_) {
    return left(const UnexpectedFailure('Unexpected request failure'));
  }
}

Dio createApiClient({
  required Uri baseUri,
  required Future<String?> Function() readToken,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUri.toString(),
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = options.uri.origin == baseUri.origin
              ? await readToken()
              : null;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        } catch (error, stackTrace) {
          handler.reject(
            DioException(
              requestOptions: options,
              error: error,
              stackTrace: stackTrace,
            ),
          );
        }
      },
    ),
  );
  // Only record method and status; URLs, headers, and bodies may contain secrets.
  dio.interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint(
            'HTTP ${response.requestOptions.method}: ${response.statusCode}',
          );
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          debugPrint('HTTP ${error.requestOptions.method}: failed');
        }
        handler.next(error);
      },
    ),
  );
  return dio;
}
