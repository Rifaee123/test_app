import 'package:flutter/material.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/attendance/presentation/pages/attendance_page.dart';
import 'package:test_app/features/courses/presentation/pages/courses_page.dart';
import 'package:test_app/features/marks/presentation/pages/marks_page.dart';
import 'package:test_app/features/profile/presentation/pages/profile_page.dart';

class DashboardRouter {
  static void navigateToAttendance(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AttendancePage()));
  }

  static void navigateToCourses(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CoursesPage()));
  }

  static void navigateToMarks(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MarksPage()));
  }

  static void navigateToProfile(BuildContext context, Student student) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ProfilePage(student: student)));
  }
}
