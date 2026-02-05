import 'package:flutter/material.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/features/admin/presentation/view/admin_keys.dart';
import 'admin_dashboard_bloc.dart';
import 'admin_states.dart';

class ActiveStudentsGenerator implements IStatGenerator {
  @override
  DashboardStat generate(List<dynamic> data) {
    final students = data.cast<Student>();
    return DashboardStat(
      testKey: AdminKeys.statCardActiveStudents,
      title: 'Active Students',
      value: students.length.toString(),
      icon: Icons.school_rounded,
      color: AppTheme.primaryColor,
    );
  }
}

class TotalDivisionsGenerator implements IStatGenerator {
  @override
  DashboardStat generate(List<dynamic> data) {
    final students = data.cast<Student>();
    final divisions = students.map((s) => s.division).toSet().length;
    return DashboardStat(
      title: 'Total Divisions',
      value: divisions.toString(),
      icon: Icons.groups_rounded,
      color: Colors.orange.shade700,
    );
  }
}

class AvgSubjectsGenerator implements IStatGenerator {
  @override
  DashboardStat generate(List<dynamic> data) {
    final students = data.cast<Student>();
    final avgSubjects = students.isEmpty
        ? '0.0'
        : (students.fold(0, (sum, s) => sum + s.subjects.length) /
                  students.length)
              .toStringAsFixed(1);

    return DashboardStat(
      title: 'Avg. Subjects',
      value: avgSubjects,
      icon: Icons.book_rounded,
      color: Colors.teal.shade700,
    );
  }
}
