/// API endpoint paths
/// These paths are appended to the base URL configured in AppConfig
class ApiEndpoints {
  // Private constructor to prevent instantiation
  ApiEndpoints._();

  // Base API path
  static const String _apiBase = '/api';

  // Auth endpoints
  static const String login = '$_apiBase/auth/login';
}
