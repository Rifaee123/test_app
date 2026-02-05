import 'package:equatable/equatable.dart';
import 'package:test_app/core/entities/student.dart';

abstract class AdminEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAdminDataEvent extends AdminEvent {}

class LoadStudentDetailEvent extends AdminEvent {
  final String studentId;
  LoadStudentDetailEvent(this.studentId);
  @override
  List<Object?> get props => [studentId];
}

class AddStudentEvent extends AdminEvent {
  final Student student;
  AddStudentEvent(this.student);
  @override
  List<Object?> get props => [student];
}

class UpdateStudentEvent extends AdminEvent {
  final Student student;
  UpdateStudentEvent(this.student);
  @override
  List<Object?> get props => [student];
}

class DeleteStudentEvent extends AdminEvent {
  final String studentId;
  DeleteStudentEvent(this.studentId);
  @override
  List<Object?> get props => [studentId];
}
