import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/student/presentation/interactor/student_interactor.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final StudentInteractor _studentInteractor;

  DashboardBloc(this._studentInteractor) : super(DashboardInitial()) {
    on<DashboardStarted>(_onDashboardStarted);
  }

  Future<void> _onDashboardStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final result = await _studentInteractor.fetchProfile(event.studentId);

    result.fold(
      (error) => emit(DashboardError(error.message)),
      (student) => emit(DashboardLoaded(student)),
    );
  }
}
