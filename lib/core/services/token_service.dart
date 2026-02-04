import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing JWT authentication tokens
class TokenService {
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';

  TokenService(this._prefs);

  /// Save the JWT token
  Future<bool> saveToken(String token) async {
    return await _prefs.setString(_tokenKey, token);
  }

  /// Get the saved JWT token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Remove the saved JWT token
  Future<bool> removeToken() async {
    return await _prefs.remove(_tokenKey);
  }

  /// Check if a token exists
  bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}
