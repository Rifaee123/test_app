import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:test_app/features/admin/presentation/pages/admin_home_page.dart';
import 'package:test_app/features/admin/presentation/pages/student_detail_page.dart';
import 'package:test_app/features/admin/presentation/pages/student_form_page.dart';

class AdminRouter {
  static void navigateToAdminHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<AdminBloc>()..add(LoadAdminDataEvent()),
          child: const AdminHomePage(),
        ),
      ),
    );
  }

  static void navigateToStudentDetail(BuildContext context, Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailPage(student: student),
      ),
    );
  }

  static void navigateToStudentForm(BuildContext context, {Student? student}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentFormPage(student: student),
      ),
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
