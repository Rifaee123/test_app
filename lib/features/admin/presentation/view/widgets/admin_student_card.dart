import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100, width: 1),
          ),
          child: InkWell(
            onTap: () => context
                .read<AdminPresenter>()
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
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 12.w,
                        backgroundColor: AppTheme.primaryColor.withOpacity(
                          0.08,
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
                        .read<AdminPresenter>()
                        .router
                        .navigateToStudentForm(context, student: student),
                  ),
                  SizedBox(width: 8.w),
                  _AnimatedActionButton(
                    testKey: ValueKey(AdminKeys.deleteStudentBtn(student.id)),
                    icon: Icons.delete_rounded,
                    color: Colors.red.shade600,
                    onPressed: () => _showDeleteConfirmation(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showGeneralDialog(
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
              title: Text(
                'Delete Student',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Are you sure you want to delete ${student.name}?',
                style: TextStyle(fontSize: 10.sp),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(fontSize: 9.sp)),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<AdminPresenter>().add(
                      DeleteStudentEvent(student.id),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    minimumSize: Size(60.w, 30.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white, fontSize: 9.sp),
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
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 11.sp, color: color),
      ),
    );
  }
}
