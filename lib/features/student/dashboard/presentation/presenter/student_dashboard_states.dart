import 'package:equatable/equatable.dart';
import 'package:test_app/core/entities/student.dart';

abstract class StudentDashboardState extends Equatable {
  const StudentDashboardState();

  @override
  List<Object?> get props => [];
}

class StudentDashboardInitial extends StudentDashboardState {}

class StudentDashboardLoading extends StudentDashboardState {}

class StudentDashboardLoaded extends StudentDashboardState {
  final Student student;

  const StudentDashboardLoaded(this.student);

  @override
  List<Object?> get props => [student];
}

class StudentDashboardError extends StudentDashboardState {
  final String message;

  const StudentDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
