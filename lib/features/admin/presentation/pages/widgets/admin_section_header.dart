import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/theme/app_theme.dart';

class AdminSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAddPressed;

  const AdminSectionHeader({
    super.key,
    required this.title,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 10.sp,
          ),
        ),
        IconButton(
          onPressed: onAddPressed,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            Icons.add_circle,
            color: AppTheme.primaryColor,
            size: 14.sp,
          ),
        ),
      ],
    );
  }
}
