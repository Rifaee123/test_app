import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/features/admin/domain/interactor/profile_interactor.dart';
import 'package:test_app/features/admin/domain/interactor/student_interactor.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_dashboard_bloc.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_events.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_states.dart';
import 'package:test_app/features/admin/presentation/router/admin_router.dart';

class MockProfileInteractor extends Mock implements IProfileInteractor {}

class MockStudentReader extends Mock implements IStudentReader {}

class MockAdminRouter extends Mock implements IAdminRouter {}

class MockStatGenerator extends Mock implements IStatGenerator {}

void main() {
  late AdminDashboardBloc bloc;
  late MockProfileInteractor mockProfileInteractor;
  late MockStudentReader mockStudentReader;
  late MockAdminRouter mockAdminRouter;
  late MockStatGenerator mockStatGenerator;

  const tTeacher = Teacher(
    id: '1',
    name: 'Teacher',
    email: 't@t.com',
    department: 'Science',
    subject: 'Math',
  );

  const tStudent = Student(
    id: '1',
    name: 'Test',
    email: 'test@test.com',
    subjects: [],
    dateOfBirth: '2000-01-01',
    division: 'A',
    parentName: 'Parent',
    parentPhone: '555-5555',
  );

  const tStat = DashboardStat(
    title: 'Test Stat',
    value: '10',
    icon: Icons.abc,
    color: Colors.red,
  );

  setUp(() {
    mockProfileInteractor = MockProfileInteractor();
    mockStudentReader = MockStudentReader();
    mockAdminRouter = MockAdminRouter();
    mockStatGenerator = MockStatGenerator();
    bloc = AdminDashboardBloc(
      profileInteractor: mockProfileInteractor,
      studentReader: mockStudentReader,
      router: mockAdminRouter,
      statGenerators: [mockStatGenerator],
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is AdminInitial', () {
    expect(bloc.state, AdminInitial());
  });

  blocTest<AdminDashboardBloc, AdminState>(
    'emits [AdminLoading, AdminLoaded] when LoadAdminDataEvent is added and succeeds',
    build: () {
      when(
        () => mockProfileInteractor.getProfile(),
      ).thenAnswer((_) async => tTeacher);
      when(
        () => mockStudentReader.getStudents(),
      ).thenAnswer((_) async => [tStudent]);
      when(() => mockStatGenerator.generate(any())).thenReturn(tStat);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadAdminDataEvent()),
    expect: () => [
      AdminLoading(),
      AdminLoaded(user: tTeacher, students: [tStudent], stats: [tStat]),
    ],
    verify: (_) {
      verify(() => mockProfileInteractor.getProfile()).called(1);
      verify(() => mockStudentReader.getStudents()).called(1);
      verify(() => mockStatGenerator.generate([tStudent])).called(1);
    },
  );

  blocTest<AdminDashboardBloc, AdminState>(
    'emits [AdminLoading, AdminError] when LoadAdminDataEvent is added and fails',
    build: () {
      when(
        () => mockProfileInteractor.getProfile(),
      ).thenThrow(Exception('Error'));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadAdminDataEvent()),
    expect: () => [
      AdminLoading(),
      AdminError('Failed to load admin dashboard'),
    ],
  );
}
