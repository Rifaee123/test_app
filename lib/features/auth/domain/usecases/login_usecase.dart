import 'package:test_app/core/entities/user.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:test_app/features/auth/domain/value_objects/auth_id.dart';
import 'package:test_app/features/auth/domain/value_objects/password.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User?> execute({required AuthId authId, required Password password}) {
    // Open/Closed Principle: No need to check for specific ID types.
    // We just pass the value to the repository.
    return _repository.login(authId.value, password.value);
  }
}
