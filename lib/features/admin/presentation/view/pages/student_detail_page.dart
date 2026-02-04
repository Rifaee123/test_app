import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_presenter.dart';
import 'package:test_app/features/admin/presentation/view/admin_keys.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;

  const StudentDetailPage({super.key, required this.student});

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentManagementBloc>().add(
        LoadStudentDetailEvent(widget.student.id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentManagementBloc, AdminState>(
      builder: (context, state) {
        final student = state is StudentDetailLoaded
            ? state.student
            : widget.student;

        return Scaffold(
          key: AdminKeys.studentDetailView,
          appBar: AppBar(
            title: const Text('Student Details'),
            leading: BackButton(
              key: AdminKeys.backButton,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Semantics(
            label: 'Student detailed information scroll view',
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  _buildHeader(context, student),
                  SizedBox(height: 24.h),
                  if (state is AdminLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Semantics(
                      key: AdminKeys.studentDetailCard,
                      label: 'Student information list',
                      child: _buildInfoList(context, student),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Student student) {
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

  Widget _buildInfoList(BuildContext context, Student student) {
    return Column(
      children: [
        _InfoTile(
          label: 'Student ID',
          value: student.id,
          icon: Icons.badge_outlined,
        ),
        _InfoTile(
          label: 'Division',
          value: student.division,
          icon: Icons.class_outlined,
        ),
        _InfoTile(
          label: 'Date of Birth',
          value: student.dateOfBirth,
          icon: Icons.cake_outlined,
        ),
        _InfoTile(
          label: 'Parent Name',
          value: student.parentName,
          icon: Icons.person_outline,
        ),
        _InfoTile(
          label: 'Parent Phone',
          value: student.parentPhone ?? 'N/A',
          icon: Icons.phone_outlined,
        ),
        _InfoTile(
          label: 'Subjects',
          value: student.subjects.join(', '),
          icon: Icons.book_outlined,
        ),
        if (student.address != null && student.address!.isNotEmpty)
          _InfoTile(
            label: 'Address',
            value: student.address!,
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
