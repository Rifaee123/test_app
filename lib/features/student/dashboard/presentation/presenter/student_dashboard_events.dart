import 'package:equatable/equatable.dart';

abstract class StudentDashboardEvent extends Equatable {
  const StudentDashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchStudentData extends StudentDashboardEvent {
  final String studentId;

  const FetchStudentData(this.studentId);

  @override
  List<Object?> get props => [studentId];
}
