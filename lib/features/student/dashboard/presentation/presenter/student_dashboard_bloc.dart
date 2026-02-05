import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/student/dashboard/domain/usecases/dashboard_interactor.dart';
import '../model/student_dashboard_view_model.dart';
import 'student_dashboard_events.dart';
import 'student_dashboard_states.dart';

class StudentDashboardBloc
    extends Bloc<StudentDashboardEvent, StudentDashboardState> {
  final IDashboardInteractor _interactor;

  StudentDashboardBloc(this._interactor) : super(StudentDashboardInitial()) {
    on<FetchStudentData>(_onFetchStudentData);
  }

  Future<void> _onFetchStudentData(
    FetchStudentData event,
    Emitter<StudentDashboardState> emit,
  ) async {
    emit(StudentDashboardLoading());
    try {
      final student = await _interactor.refreshStudentData(event.studentId);
      final viewModel = StudentDashboardViewModel.fromEntity(student);
      emit(StudentDashboardLoaded(viewModel));
    } catch (e) {
      emit(StudentDashboardError(e.toString()));
    }
  }
}
