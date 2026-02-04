import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/core/storage/local_storage_service.dart';

/// Implementation of LocalStorageService using SharedPreferences
/// Follows Single Responsibility Principle - only handles SharedPreferences operations
class SharedPrefsLocalStorageService implements LocalStorageService {
  static const String _tokenKey = 'auth_token';
  final SharedPreferences _prefs;

  SharedPrefsLocalStorageService(this._prefs);

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }

  @override
  Future<bool> hasToken() async {
    return _prefs.containsKey(_tokenKey);
  }

  static const String _roleKey = 'user_role';

  @override
  Future<void> saveRole(String role) async {
    await _prefs.setString(_roleKey, role);
  }

  @override
  Future<String?> getRole() async {
    return _prefs.getString(_roleKey);
  }

  @override
  Future<void> clearRole() async {
    await _prefs.remove(_roleKey);
  }

  static const String _userIdKey = 'user_id';

  @override
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  @override
  Future<String?> getUserId() async {
    return _prefs.getString(_userIdKey);
  }

  @override
  Future<void> clearUserId() async {
    await _prefs.remove(_userIdKey);
  }
}
