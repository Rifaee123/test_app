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
}
