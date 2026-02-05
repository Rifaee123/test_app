import 'package:flutter/foundation.dart';

class AuthKeys {
  // Pages
  static const Key landingPage = ValueKey('landingPage');
  static const Key loginPage = ValueKey('loginPage');

  // Landing Page Elements
  static const Key loginButton = ValueKey('loginButton');
  static const Key registerButton = ValueKey('registerButton');

  // Login Page Elements
  static const Key emailInput = ValueKey('emailInput');
  static const Key passwordInput = ValueKey('passwordInput');
  static const Key loginSubmitButton = ValueKey('loginSubmitButton');
  static const Key forgotPasswordButton = ValueKey('forgotPasswordButton');
}
