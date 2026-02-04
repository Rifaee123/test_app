import 'package:dio/dio.dart';
import 'package:test_app/core/services/token_service.dart';

/// Interceptor for adding authentication tokens to requests
/// Automatically adds Authorization header to all requests
class AuthInterceptor extends Interceptor {
  final TokenService _tokenService;

  AuthInterceptor(this._tokenService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Skip adding token for login endpoint
    if (options.path.contains('/login')) {
      return super.onRequest(options, handler);
    }

    // Add Authorization header if token exists in TokenService
    final token = _tokenService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Clear token on 401 Unauthorized
    if (err.response?.statusCode == 401) {
      _tokenService.removeToken();
    }
    super.onError(err, handler);
  }
}
