import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/features/admin/presentation/view/admin_keys.dart';

class AdminWelcomeHeader extends StatelessWidget {
  final Teacher teacher;

  const AdminWelcomeHeader({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: AdminKeys.welcomeHeader,
      label: 'Welcome header for ${teacher.name}',
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, -10 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 1,
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
                SizedBox(width: 4.w),
                Text(
                  'WELCOME BACK',
                  style: TextStyle(
                    color: AppTheme.primaryColor.withOpacity(0.7),
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              teacher.name,
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${teacher.subject} • ${teacher.department}',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 7.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
