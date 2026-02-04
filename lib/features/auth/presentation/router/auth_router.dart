import 'package:flutter/material.dart';
import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/services/navigation_service.dart';
import 'package:test_app/features/auth/presentation/router/auth_navigation.dart';
import 'package:test_app/features/auth/presentation/view/login_page.dart';
import 'package:test_app/features/student/dashboard/presentation/pages/dashboard_page.dart';
import 'package:test_app/core/entities/student.dart';

class AuthRouter implements AuthNavigation {
  final NavigationService navigationService;

  AuthRouter(this.navigationService);

  @override
  void goToLogin({required bool isAdmin}) {
    navigationService.push(
      MaterialPageRoute(builder: (_) => LoginPage(isAdmin: isAdmin)),
    );
  }

  @override
  void goToDashboard(User user) {
    if (user is Student) {
      navigationService.pushReplacement(
        MaterialPageRoute(builder: (_) => DashboardPage(student: user)),
      );
    }
  }
}
