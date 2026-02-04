/// Data Transfer Object for login request
/// Follows Single Responsibility Principle - only handles request data structure
class LoginRequestDto {
  final String username;
  final String password;
  final String role;

  const LoginRequestDto({
    required this.username,
    required this.password,
    required this.role,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password, 'role': role};
  }
}
