import 'package:test_app/core/storage/local_storage_service.dart';

class AuthStatus {
  final bool isAuthenticated;
  final String? role;
  final String? userId;
  final String? token;

  AuthStatus({
    required this.isAuthenticated,
    this.role,
    this.userId,
    this.token,
  });
}

class CheckAuthStatusUseCase {
  final LocalStorageService _localStorageService;

  CheckAuthStatusUseCase(this._localStorageService);

  Future<AuthStatus> execute() async {
    final hasToken = await _localStorageService.hasToken();
    if (!hasToken) {
      return AuthStatus(isAuthenticated: false);
    }

    final token = await _localStorageService.getToken();
    final role = await _localStorageService.getRole();
    final userId = await _localStorageService.getUserId();

    return AuthStatus(
      isAuthenticated: true,
      role: role,
      userId: userId,
      token: token,
    );
  }
}
