/// Abstract interface for local storage operations
/// Follows Interface Segregation Principle - defines contract for storage
/// Follows Dependency Inversion Principle - allows depending on abstraction
abstract class LocalStorageService {
  /// Save the authentication token
  Future<void> saveToken(String token);

  /// Retrieve the authentication token
  Future<String?> getToken();

  /// Clear the authentication token (logout)
  Future<void> clearToken();

  /// Check if a token exists
  Future<bool> hasToken();

  /// Save the user role
  Future<void> saveRole(String role);

  /// Get the user role
  Future<String?> getRole();

  /// Clear the user role
  Future<void> clearRole();

  /// Save the user ID
  Future<void> saveUserId(String userId);

  /// Get the user ID
  Future<String?> getUserId();

  /// Clear the user ID
  Future<void> clearUserId();
}
