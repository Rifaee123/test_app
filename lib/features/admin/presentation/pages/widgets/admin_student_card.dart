import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:test_app/features/admin/presentation/router/admin_router.dart';

class AdminStudentCard extends StatelessWidget {
  final Student student;

  const AdminStudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.005),
            blurRadius: 2,
            offset: const Offset(0, 0.2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => AdminRouter.navigateToStudentDetail(context, student),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 10.w,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  student.name.substring(0, 1),
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 9.sp,
                        color: AppTheme.textColor,
                      ),
                    ),
                    Text(
                      'ID: ${student.id} | ${student.division}',
                      style: TextStyle(
                        color: AppTheme.softTextColor,
                        fontSize: 7.sp,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => AdminRouter.navigateToStudentForm(
                  context,
                  student: student,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.edit_outlined,
                  size: 12.sp,
                  color: Colors.blue.shade600,
                ),
              ),
              SizedBox(width: 6.w),
              IconButton(
                onPressed: () => _showDeleteConfirmation(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.delete_outline,
                  size: 12.sp,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AdminBloc>().add(DeleteStudentEvent(student.id));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
