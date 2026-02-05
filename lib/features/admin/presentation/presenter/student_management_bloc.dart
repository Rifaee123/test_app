import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/admin/domain/interactor/student_interactor.dart';
import 'package:test_app/features/admin/presentation/router/admin_router.dart';
import 'admin_events.dart';
import 'admin_states.dart';

class StudentManagementBloc extends Bloc<AdminEvent, AdminState> {
  final IStudentReader _studentReader;
  final IStudentWriter _studentWriter;
  final IAdminRouter router;

  StudentManagementBloc({
    required IStudentReader studentReader,
    required IStudentWriter studentWriter,
    required this.router,
  }) : _studentReader = studentReader,
       _studentWriter = studentWriter,
       super(AdminInitial()) {
    on<LoadStudentDetailEvent>(_onLoadStudentDetail);
    on<AddStudentEvent>(_onAddStudent);
    on<UpdateStudentEvent>(_onUpdateStudent);
    on<DeleteStudentEvent>(_onDeleteStudent);
  }

  Future<void> _onLoadStudentDetail(
    LoadStudentDetailEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      final student = await _studentReader.getStudentById(event.studentId);
      // Fixed LSP: No longer forces dummy teacher/students list
      emit(StudentDetailLoaded(student: student));
    } catch (e) {
      emit(AdminError('Failed to load student details'));
    }
  }

  Future<void> _onAddStudent(
    AddStudentEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      await _studentWriter.addStudent(event.student);
      emit(StudentOperationSuccess(message: 'Student created successfully'));
    } catch (e) {
      emit(AdminError('Failed to add student'));
    }
  }

  Future<void> _onUpdateStudent(
    UpdateStudentEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      await _studentWriter.updateStudent(event.student);
      emit(StudentOperationSuccess(message: 'Student updated successfully'));
    } catch (e) {
      emit(AdminError('Failed to update student'));
    }
  }

  Future<void> _onDeleteStudent(
    DeleteStudentEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      await _studentWriter.deleteStudent(event.studentId);
      emit(StudentOperationSuccess(message: 'Student deleted successfully'));
    } catch (e) {
      emit(AdminError('Failed to delete student'));
    }
  }
}
