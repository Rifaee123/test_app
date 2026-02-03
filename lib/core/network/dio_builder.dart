import 'package:dio/dio.dart';

/// Builder class for creating and configuring Dio instances
/// Follows the Builder Pattern for flexible and extensible configuration
class DioBuilder {
  String? _baseUrl;
  Duration _connectTimeout = const Duration(seconds: 30);
  Duration _receiveTimeout = const Duration(seconds: 30);
  Duration _sendTimeout = const Duration(seconds: 30);
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  final List<Interceptor> _interceptors = [];

  /// Set the base URL for all requests
  DioBuilder setBaseUrl(String url) {
    _baseUrl = url;
    return this;
  }

  /// Configure timeout durations
  DioBuilder setTimeouts({
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) {
    if (connectTimeout != null) _connectTimeout = connectTimeout;
    if (receiveTimeout != null) _receiveTimeout = receiveTimeout;
    if (sendTimeout != null) _sendTimeout = sendTimeout;
    return this;
  }

  /// Set default headers (merges with existing headers)
  DioBuilder setDefaultHeaders(Map<String, String> headers) {
    _headers.addAll(headers);
    return this;
  }

  /// Add a single interceptor
  DioBuilder addInterceptor(Interceptor interceptor) {
    _interceptors.add(interceptor);
    return this;
  }

  /// Add multiple interceptors at once
  DioBuilder addInterceptors(List<Interceptor> interceptors) {
    _interceptors.addAll(interceptors);
    return this;
  }

  /// Build and return the configured Dio instance
  Dio build() {
    if (_baseUrl == null || _baseUrl!.isEmpty) {
      throw ArgumentError('Base URL must be set before building Dio instance');
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl!,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
        headers: Map<String, String>.from(_headers),
      ),
    );

    // Add all interceptors in the order they were added
    for (final interceptor in _interceptors) {
      dio.interceptors.add(interceptor);
    }

    return dio;
  }

  /// Reset the builder to its initial state
  DioBuilder reset() {
    _baseUrl = null;
    _connectTimeout = const Duration(seconds: 30);
    _receiveTimeout = const Duration(seconds: 30);
    _sendTimeout = const Duration(seconds: 30);
    _headers.clear();
    _headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    _interceptors.clear();
    return this;
  }
}
