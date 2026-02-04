import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_presenter.dart';
import 'package:test_app/features/admin/presentation/view/admin_keys.dart';

class AdminStudentCard extends StatelessWidget {
  final Student student;

  const AdminStudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: ValueKey(AdminKeys.studentItem(student.id)),
      label: 'Student card for ${student.name}',
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100, width: 1),
          ),
          child: InkWell(
            onTap: () => context
                .read<AdminDashboardBloc>()
                .router
                .navigateToStudentDetail(context, student),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: Row(
                children: [
                  Hero(
                    tag: 'student_avatar_${student.id}',
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 12.w,
                        backgroundColor: AppTheme.primaryColor.withValues(
                          alpha: 0.08,
                        ),
                        child: Text(
                          student.name.substring(0, 1),
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 10.sp,
                            color: AppTheme.textColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          'ID: ${student.id} • ${student.division}',
                          style: TextStyle(
                            color: AppTheme.softTextColor,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _AnimatedActionButton(
                    testKey: ValueKey(AdminKeys.editStudentBtn(student.id)),
                    icon: Icons.edit_rounded,
                    color: Colors.blue.shade600,
                    onPressed: () => context
                        .read<AdminDashboardBloc>()
                        .router
                        .navigateToStudentForm(context, student: student),
                  ),
                  SizedBox(width: 8.w),
                  _AnimatedActionButton(
                    testKey: ValueKey(AdminKeys.deleteStudentBtn(student.id)),
                    icon: Icons.delete_rounded,
                    color: Colors.red.shade600,
                    onPressed: () async {
                      final confirmed = await context
                          .read<AdminDashboardBloc>()
                          .router
                          .confirmDeleteStudent(context, student.name);
                      if (confirmed == true && context.mounted) {
                        sl<StudentManagementBloc>().add(
                          DeleteStudentEvent(student.id),
                        );
                        context.read<AdminDashboardBloc>().add(
                          LoadAdminDataEvent(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final Key? testKey;

  const _AnimatedActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.testKey,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: testKey,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 11.sp, color: color),
      ),
    );
  }
}
