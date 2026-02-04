import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/network/result.dart';

abstract class AuthRepository {
  Future<Result<User?>> login(String id, String password);
  Future<Result<void>> logout();
}
