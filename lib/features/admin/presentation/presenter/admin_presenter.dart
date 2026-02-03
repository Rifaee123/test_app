import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/features/admin/domain/interactor/profile_interactor.dart';
import 'package:test_app/features/admin/domain/interactor/student_interactor.dart';
import 'package:test_app/features/admin/presentation/router/admin_router.dart';

// Events
abstract class AdminEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAdminDataEvent extends AdminEvent {}

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

// States
abstract class AdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final Teacher teacher;
  final List<Student> students;
  AdminLoaded({required this.teacher, required this.students});
  @override
  List<Object?> get props => [teacher, students];
}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
  @override
  List<Object?> get props => [message];
}

// Presenter (implemented via Bloc)
class AdminPresenter extends Bloc<AdminEvent, AdminState> {
  final IProfileInteractor _profileInteractor;
  final IStudentReader _studentReader;
  final IStudentWriter _studentWriter;
  final IAdminRouter router;

  AdminPresenter({
    required IProfileInteractor profileInteractor,
    required IStudentReader studentReader,
    required IStudentWriter studentWriter,
    required this.router,
  }) : _profileInteractor = profileInteractor,
       _studentReader = studentReader,
       _studentWriter = studentWriter,
       super(AdminInitial()) {
    on<LoadAdminDataEvent>(_onLoadAdminData);
    on<AddStudentEvent>(_onAddStudent);
    on<UpdateStudentEvent>(_onUpdateStudent);
    on<DeleteStudentEvent>(_onDeleteStudent);
  }

  Future<void> _onLoadAdminData(
    LoadAdminDataEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      final teacher = await _profileInteractor.getProfile();
      final students = await _studentReader.getStudents();
      emit(AdminLoaded(teacher: teacher, students: students));
    } catch (e) {
      emit(AdminError('Failed to load admin dashboard'));
    }
  }

  Future<void> _onAddStudent(
    AddStudentEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      await _studentWriter.addStudent(event.student);
      add(LoadAdminDataEvent());
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
      add(LoadAdminDataEvent());
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
      add(LoadAdminDataEvent());
    } catch (e) {
      emit(AdminError('Failed to delete student'));
    }
  }
}
