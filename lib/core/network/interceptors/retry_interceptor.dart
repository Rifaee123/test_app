import 'package:dio/dio.dart';

/// Interceptor for retrying failed requests
/// Automatically retries requests on network errors or timeouts
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final List<DioExceptionType> retryableErrors;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryableErrors = const [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionError,
    ],
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if error is retryable
    if (!retryableErrors.contains(err.type)) {
      return super.onError(err, handler);
    }

    // Get retry count from request options
    final extra = err.requestOptions.extra;
    final retries = extra['retries'] ?? 0;

    // Check if max retries exceeded
    if (retries >= maxRetries) {
      return super.onError(err, handler);
    }

    // Increment retry count
    extra['retries'] = retries + 1;

    print(
      'Retrying request (${retries + 1}/$maxRetries): ${err.requestOptions.uri}',
    );

    // Wait before retrying
    await Future.delayed(retryDelay * (retries + 1)); // Exponential backoff

    // Retry the request
    try {
      final response = await Dio().fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return super.onError(e, handler);
    }
  }
}
