import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_presenter.dart';
import 'package:test_app/features/admin/presentation/view/pages/admin_home_page.dart';
import 'package:test_app/features/admin/presentation/view/pages/student_detail_page.dart';
import 'package:test_app/features/admin/presentation/view/pages/student_form_page.dart';

abstract class IAdminRouter {
  void navigateToAdminHome(BuildContext context);
  void navigateToStudentDetail(BuildContext context, Student student);
  void navigateToStudentForm(BuildContext context, {Student? student});
  void pop(BuildContext context);
}

class AdminRouterImpl implements IAdminRouter {
  @override
  void navigateToAdminHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<AdminPresenter>()..add(LoadAdminDataEvent()),
          child: const AdminHomePage(),
        ),
      ),
    );
  }

  @override
  void navigateToStudentDetail(BuildContext context, Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailPage(student: student),
      ),
    );
  }

  @override
  void navigateToStudentForm(BuildContext context, {Student? student}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentFormPage(student: student),
      ),
    );
  }

  @override
  void pop(BuildContext context) => Navigator.pop(context);
}
