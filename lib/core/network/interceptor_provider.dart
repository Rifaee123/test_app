import 'package:dio/dio.dart';
import 'package:test_app/core/network/interceptors/auth_interceptor.dart';
import 'package:test_app/core/network/interceptors/logging_interceptor.dart';
import 'package:test_app/core/network/interceptors/retry_interceptor.dart';

/// Abstract interface for providing interceptors
/// Follows Strategy Pattern for flexible interceptor configuration
abstract class InterceptorProvider {
  /// Provide a list of interceptors in the desired order
  List<Interceptor> provide();
}

/// Default implementation that provides standard interceptors
/// Order: Logging -> Auth -> Retry
class DefaultInterceptorProvider implements InterceptorProvider {
  final bool enableLogging;
  final bool enableRetry;
  final int maxRetries;
  final Duration retryDelay;
  final AuthInterceptor authInterceptor;

  const DefaultInterceptorProvider({
    required this.authInterceptor,
    this.enableLogging = true,
    this.enableRetry = true,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  List<Interceptor> provide() {
    final interceptors = <Interceptor>[];

    // 1. Logging Interceptor (first to log everything)
    if (enableLogging) {
      interceptors.add(LoggingInterceptor());
    }

    // 2. Auth Interceptor (adds auth headers)
    interceptors.add(authInterceptor);

    // 3. Retry Interceptor (last to retry failed requests)
    if (enableRetry) {
      interceptors.add(
        RetryInterceptor(maxRetries: maxRetries, retryDelay: retryDelay),
      );
    }

    return interceptors;
  }
}
