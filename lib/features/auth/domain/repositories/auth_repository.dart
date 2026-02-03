import 'package:test_app/core/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String id, String password);
  Future<void> logout();
}
