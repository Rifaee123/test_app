import 'package:test_app/core/entities/student.dart';

abstract class AuthRepository {
  Future<Student?> login(String email, String password);
  Future<void> logout();
}
