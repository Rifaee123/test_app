import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/admin/domain/interactor/profile_interactor.dart';
import 'package:test_app/features/admin/domain/interactor/student_interactor.dart';
import 'package:test_app/features/admin/presentation/router/admin_router.dart';
import 'admin_events.dart';
import 'admin_states.dart';

/// Strategy Interface for generating dashboard stats (OCP 100%)
abstract class IStatGenerator {
  DashboardStat generate(List<dynamic> data);
}

class AdminDashboardBloc extends Bloc<AdminEvent, AdminState> {
  final IProfileInteractor _profileInteractor;
  final IStudentReader _studentReader;
  final IAdminRouter router;
  final List<IStatGenerator> _statGenerators;

  AdminDashboardBloc({
    required IProfileInteractor profileInteractor,
    required IStudentReader studentReader,
    required this.router,
    List<IStatGenerator> statGenerators = const [],
  }) : _profileInteractor = profileInteractor,
       _studentReader = studentReader,
       _statGenerators = statGenerators,
       super(AdminInitial()) {
    on<LoadAdminDataEvent>(_onLoadAdminData);
  }

  Future<void> _onLoadAdminData(
    LoadAdminDataEvent event,
    Emitter<AdminState> emit,
  ) async {
    if (state is! AdminLoaded) {
      emit(AdminLoading());
    }

    try {
      final teacher = await _profileInteractor.getProfile();
      final students = await _studentReader.getStudents();

      // OCP: We can add new stats by injecting new generators via DI
      final stats = _statGenerators.map((g) => g.generate(students)).toList();

      emit(AdminLoaded(user: teacher, students: students, stats: stats));
    } catch (e) {
      if (state is! AdminLoaded) {
        emit(AdminError('Failed to load admin dashboard'));
      }
    }
  }
}
