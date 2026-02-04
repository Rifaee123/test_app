import 'package:test_app/core/entities/user.dart';

abstract class AuthNavigation {
  void goToLogin({required bool isAdmin});
  void goToHome(User user);
}
