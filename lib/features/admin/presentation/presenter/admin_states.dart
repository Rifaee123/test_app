import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/user.dart';

// Stat definition for OCP
class DashboardStat extends Equatable {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Key? testKey;

  const DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.testKey,
  });

  @override
  List<Object?> get props => [title, value, icon, color, testKey];
}

abstract class AdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
  @override
  List<Object?> get props => [message];
}

// Fixed LSP: Dashboard state and Detail state are now distinct siblings
// and don't force each other to fulfill irrelevant contracts.

class AdminLoaded extends AdminState {
  final User user;
  final List<Student> students;
  final List<DashboardStat> stats;

  AdminLoaded({
    required this.user,
    required this.students,
    required this.stats,
  });

  @override
  List<Object?> get props => [user, students, stats];
}

class StudentDetailLoaded extends AdminState {
  final Student student;

  StudentDetailLoaded({required this.student});

  @override
  List<Object?> get props => [student];
}

class StudentOperationSuccess extends AdminState {
  final String message;

  StudentOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
