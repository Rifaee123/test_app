import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:test_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:test_app/features/auth/domain/value_objects/auth_id.dart';
import 'package:test_app/features/auth/domain/value_objects/password.dart';
import 'package:test_app/features/auth/presentation/router/auth_navigation.dart';

abstract class IAuthInteractor {
  Future<Result<User?>> executeLogin({
    required AuthId authId,
    required Password password,
    required String role,
  });
  void navigateToLogin({required bool isAdmin});
  Future<Result<void>> executeLogout();
}

class AuthInteractor implements IAuthInteractor {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthNavigation _navigation;

  AuthInteractor(this._loginUseCase, this._logoutUseCase, this._navigation);

  @override
  Future<Result<User?>> executeLogin({
    required AuthId authId,
    required Password password,
    required String role,
  }) async {
    final result = await _loginUseCase.execute(
      authId: authId,
      password: password,
      role: role,
    );

    // Handle navigation on successful login
    result.whenSuccess((user) {
      if (user != null) {
        _navigation.goToHome(user);
      }
    });

    return result;
  }

  @override
  void navigateToLogin({required bool isAdmin}) {
    _navigation.goToLogin(isAdmin: isAdmin);
  }

  @override
  Future<Result<void>> executeLogout() async {
    final result = await _logoutUseCase.execute();
    result.whenSuccess((_) {
      _navigation.goToLanding();
    });
    return result;
  }
}
