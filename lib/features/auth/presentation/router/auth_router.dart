import 'package:flutter/material.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/dashboard/presentation/pages/dashboard_page.dart';

class AuthRouter {
  static void navigateToDashboard(BuildContext context, Student student) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => DashboardPage(student: student)),
    );
  }
}
