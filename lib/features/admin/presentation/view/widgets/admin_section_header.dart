import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/theme/app_theme.dart';

class AdminSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAddPressed;
  final Key? testKey;

  const AdminSectionHeader({
    super.key,
    required this.title,
    required this.onAddPressed,
    this.testKey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Semantics(
          identifier:
              '${title.toLowerCase().replaceAll(' ', '_')}_section_header',
          header: true,
          label: '$title Section Header',
          child: Text(
            title,
            key: ValueKey('${title.toLowerCase().replaceAll(' ', '_')}_header'),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
          ),
        ),
        Semantics(
          identifier: testKey is ValueKey<String>
              ? (testKey as ValueKey<String>).value
              : null,
          label: 'Add New Student Button',
          button: true,
          hint: 'Navigates to the form to add a new student',
          child: ElevatedButton.icon(
            key: testKey,
            onPressed: onAddPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              foregroundColor: AppTheme.primaryColor,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: Icon(Icons.add_circle_outline_rounded, size: 10.sp),
            label: Text(
              'Add Student',
              style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
}
