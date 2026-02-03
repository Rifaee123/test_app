import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/core/theme/app_theme.dart';

class AdminWelcomeHeader extends StatelessWidget {
  final Teacher teacher;

  const AdminWelcomeHeader({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: TextStyle(color: AppTheme.softTextColor, fontSize: 8.sp),
        ),
        Text(
          teacher.name,
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${teacher.subject} | ${teacher.department}',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 8.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
