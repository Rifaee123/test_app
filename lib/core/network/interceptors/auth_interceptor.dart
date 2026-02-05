import 'package:dio/dio.dart';
import 'package:test_app/core/storage/local_storage_service.dart';

/// Interceptor for adding authentication tokens to requests
/// Automatically adds Authorization header to all requests
/// Follows Dependency Inversion Principle - depends on abstraction
class AuthInterceptor extends Interceptor {
  final LocalStorageService _localStorageService;

  AuthInterceptor(this._localStorageService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding token for login endpoint
    if (options.path.contains('/login')) {
      return super.onRequest(options, handler);
    }

    // Get token from secure storage
    final token = await _localStorageService.getToken();

    // Add Authorization header if token exists
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Clear token on 401 Unauthorized
    if (err.response?.statusCode == 401) {
      await _localStorageService.clearToken();
    }
    super.onError(err, handler);
  }
}
