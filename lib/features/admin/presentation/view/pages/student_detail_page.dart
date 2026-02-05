import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/features/admin/presentation/view/admin_keys.dart';

class StudentDetailPage extends StatelessWidget {
  final Student student;

  const StudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AdminKeys.studentDetailView,
      appBar: AppBar(
        title: const Text('Student Details'),
        leading: BackButton(key: AdminKeys.backButton),
      ),
      body: Semantics(
        label: 'Student detailed information scroll view',
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 24.h),
              Semantics(
                key: AdminKeys.studentDetailCard,
                label: 'Student information list',
                child: _buildInfoList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: const Icon(
            Icons.person,
            color: AppTheme.primaryColor,
            size: 50,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          student.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'Student ID: ${student.id}',
          style: const TextStyle(color: AppTheme.softTextColor),
        ),
      ],
    );
  }

  Widget _buildInfoList(BuildContext context) {
    return Column(
      children: [
        _InfoTile(
          label: 'Email',
          value: student.email,
          icon: Icons.email_outlined,
        ),
        _InfoTile(
          label: 'Phone',
          value: student.phone ?? '',
          icon: Icons.phone_outlined,
        ),
        _InfoTile(
          label: 'Division',
          value: student.division,
          icon: Icons.class_outlined,
        ),
        _InfoTile(
          label: 'Semester',
          value: student.semester,
          icon: Icons.calendar_today_outlined,
        ),
        _InfoTile(
          label: 'Attendance',
          value: '${student.attendance}%',
          icon: Icons.check_circle_outline,
        ),
        _InfoTile(
          label: 'Avg Marks',
          value: '${student.averageMarks}%',
          icon: Icons.grade_outlined,
        ),
        _InfoTile(
          label: 'Parent Name',
          value: student.parentName,
          icon: Icons.family_restroom_outlined,
        ),
        _InfoTile(
          label: 'Address',
          value: student.address ?? '',
          icon: Icons.location_on_outlined,
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.softTextColor,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
