import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Result<void>> execute() {
    return _repository.logout();
  }
}
