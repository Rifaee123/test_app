import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/student/dashboard/domain/usecases/dashboard_interactor.dart';
import 'package:test_app/features/student/dashboard/presentation/model/student_dashboard_view_model.dart';
import 'package:test_app/features/student/dashboard/presentation/presenter/student_dashboard_bloc.dart';
import 'package:test_app/features/student/dashboard/presentation/presenter/student_dashboard_events.dart';
import 'package:test_app/features/student/dashboard/presentation/presenter/student_dashboard_states.dart';

class MockDashboardInteractor extends Mock implements IDashboardInteractor {}

void main() {
  late StudentDashboardBloc dashboardBloc;
  late MockDashboardInteractor mockInteractor;

  setUp(() {
    mockInteractor = MockDashboardInteractor();
    dashboardBloc = StudentDashboardBloc(mockInteractor);
  });

  tearDown(() {
    dashboardBloc.close();
  });

  group('StudentDashboardBloc', () {
    const tStudentId = 'student_1';
    final tStudent = Student(
      id: tStudentId,
      name: 'John Doe',
      email: 'john@example.com',
      subjects: ['Math'],
    );
    final tViewModel = StudentDashboardViewModel.fromEntity(tStudent);

    test('initial state should be StudentDashboardInitial', () {
      expect(dashboardBloc.state, isA<StudentDashboardInitial>());
    });

    blocTest<StudentDashboardBloc, StudentDashboardState>(
      'should emit [Loading, Loaded] when data is fetched successfully',
      build: () {
        when(
          () => mockInteractor.refreshStudentData(tStudentId),
        ).thenAnswer((_) async => tStudent);
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(const FetchStudentData(tStudentId)),
      expect: () => [
        isA<StudentDashboardLoading>(),
        StudentDashboardLoaded(tViewModel),
      ],
      verify: (_) {
        verify(() => mockInteractor.refreshStudentData(tStudentId)).called(1);
      },
    );

    blocTest<StudentDashboardBloc, StudentDashboardState>(
      'should emit [Loading, Error] when data fetching fails',
      build: () {
        when(
          () => mockInteractor.refreshStudentData(tStudentId),
        ).thenThrow(Exception('Server error'));
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(const FetchStudentData(tStudentId)),
      expect: () => [
        isA<StudentDashboardLoading>(),
        const StudentDashboardError('Exception: Server error'),
      ],
    );
  });
}
