import 'package:test_app/core/entities/user.dart';
import 'package:test_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:test_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:test_app/features/auth/domain/value_objects/auth_id.dart';
import 'package:test_app/features/auth/domain/value_objects/password.dart';
import 'package:test_app/features/auth/presentation/router/auth_navigation.dart';

class AuthInteractor {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthNavigation _navigation;

  AuthInteractor(this._loginUseCase, this._logoutUseCase, this._navigation);

  Future<User?> executeLogin({
    required AuthId authId,
    required Password password,
  }) async {
    final user = await _loginUseCase.execute(
      authId: authId,
      password: password,
    );
    if (user != null) {
      _navigation.goToDashboard(user);
    }
    return user;
  }

  void navigateToLogin({required bool isAdmin}) {
    _navigation.goToLogin(isAdmin: isAdmin);
  }

  Future<void> executeLogout() {
    return _logoutUseCase.execute();
  }
}
