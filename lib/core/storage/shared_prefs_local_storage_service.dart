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
}
