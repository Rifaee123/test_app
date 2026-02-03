import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';

class AuthInteractor {
  final AuthRepository repository;

  AuthInteractor(this.repository);

  Future<Student?> executeLogin(String email, String password) {
    return repository.login(email, password);
  }
}
