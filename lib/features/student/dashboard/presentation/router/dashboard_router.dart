import 'package:flutter/material.dart';
import 'package:test_app/core/entities/student.dart';

abstract class IDashboardRouter {
  // Define navigation methods here as needed
}

class DashboardRouter implements IDashboardRouter {
  static void navigateToProfile(BuildContext context, Student student) {
    // Navigate to profile page
    // Using simple navigation for now, can be replaced with named routes
    /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfilePage(student: student),
      ),
    );
    */
    // Since ProfilePage import might be missing or circular,
    // we'll assume a named route or just print for now if not implemented.
    // Actually, looking at side_bar, it uses keys. Logic suggests:
    Navigator.pushNamed(context, '/profile', arguments: student);
  }
}
