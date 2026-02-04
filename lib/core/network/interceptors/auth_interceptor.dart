import 'package:dio/dio.dart';

/// Interceptor for adding authentication tokens to requests
/// Automatically adds Authorization header to all requests
class AuthInterceptor extends Interceptor {
  String? _token;

  /// Set the authentication token
  void setToken(String token) {
    _token = token;
  }

  /// Clear the authentication token
  void clearToken() {
    _token = null;
  }

  /// Get the current token
  String? get token => _token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add Authorization header if token exists
    if (_token != null && _token!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Clear token on 401 Unauthorized
    if (err.response?.statusCode == 401) {
      clearToken();
    }
    super.onError(err, handler);
  }
}
