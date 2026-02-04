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
  Future<bool?> confirmDeleteStudent(BuildContext context, String studentName);
}

class AdminRouterImpl implements IAdminRouter {
  @override
  void navigateToAdminHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              sl<AdminDashboardBloc>()..add(LoadAdminDataEvent()),
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
        builder: (context) => BlocProvider(
          create: (context) =>
              sl<StudentManagementBloc>()
                ..add(LoadStudentDetailEvent(student.id)),
          child: StudentDetailPage(student: student),
        ),
      ),
    );
  }

  @override
  void navigateToStudentForm(BuildContext context, {Student? student}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<StudentManagementBloc>(),
          child: StudentFormPage(student: student),
        ),
      ),
    );
  }

  @override
  void pop(BuildContext context) => Navigator.pop(context);

  @override
  Future<bool?> confirmDeleteStudent(BuildContext context, String studentName) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text('Delete Student'),
              content: Text('Are you sure you want to delete $studentName?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
