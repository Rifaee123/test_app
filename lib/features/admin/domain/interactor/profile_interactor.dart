import 'package:test_app/core/entities/user.dart';

abstract class IProfileInteractor {
  Future<User> getProfile();
}
