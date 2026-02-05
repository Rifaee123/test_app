import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/domain/interactor/student_interactor.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_events.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_states.dart';
import 'package:test_app/features/admin/presentation/presenter/student_management_bloc.dart';
import 'package:test_app/features/admin/presentation/router/admin_router.dart';

class MockStudentReader extends Mock implements IStudentReader {}

class MockStudentWriter extends Mock implements IStudentWriter {}

class MockAdminRouter extends Mock implements IAdminRouter {}

void main() {
  late StudentManagementBloc bloc;
  late MockStudentReader mockStudentReader;
  late MockStudentWriter mockStudentWriter;
  late MockAdminRouter mockAdminRouter;

  const tStudent = Student(
    id: '1',
    name: 'Test',
    email: 'test@test.com',
    subjects: [],
  );

  setUpAll(() {
    registerFallbackValue(
      const Student(id: '0', name: 'Fallback', email: 'f@f.com', subjects: []),
    );
  });

  setUp(() {
    mockStudentReader = MockStudentReader();
    mockStudentWriter = MockStudentWriter();
    mockAdminRouter = MockAdminRouter();
    bloc = StudentManagementBloc(
      studentReader: mockStudentReader,
      studentWriter: mockStudentWriter,
      router: mockAdminRouter,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is AdminInitial', () {
    expect(bloc.state, AdminInitial());
  });

  blocTest<StudentManagementBloc, AdminState>(
    'emits [AdminLoading, StudentDetailLoaded] when LoadStudentDetailEvent is added and succeeds',
    build: () {
      when(
        () => mockStudentReader.getStudentById(any()),
      ).thenAnswer((_) async => tStudent);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadStudentDetailEvent('1')),
    expect: () => [AdminLoading(), StudentDetailLoaded(student: tStudent)],
    verify: (_) {
      verify(() => mockStudentReader.getStudentById('1')).called(1);
    },
  );

  blocTest<StudentManagementBloc, AdminState>(
    'emits [AdminLoading, AdminError] when LoadStudentDetailEvent is added and fails',
    build: () {
      when(
        () => mockStudentReader.getStudentById(any()),
      ).thenThrow(Exception('Error'));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadStudentDetailEvent('1')),
    expect: () => [
      AdminLoading(),
      AdminError('Failed to load student details'),
    ],
  );

  blocTest<StudentManagementBloc, AdminState>(
    'emits [StudentOperationSuccess] when AddStudentEvent is added and succeeds',
    build: () {
      when(() => mockStudentWriter.addStudent(any())).thenAnswer((_) async {});
      return bloc;
    },
    act: (bloc) => bloc.add(AddStudentEvent(tStudent)),
    expect: () => [
      StudentOperationSuccess(message: 'Student created successfully'),
    ],
    verify: (_) {
      verify(() => mockStudentWriter.addStudent(tStudent)).called(1);
    },
  );

  blocTest<StudentManagementBloc, AdminState>(
    'emits [AdminError] when AddStudentEvent is added and fails',
    build: () {
      when(
        () => mockStudentWriter.addStudent(any()),
      ).thenThrow(Exception('Error'));
      return bloc;
    },
    act: (bloc) => bloc.add(AddStudentEvent(tStudent)),
    expect: () => [AdminError('Failed to add student')],
  );

  blocTest<StudentManagementBloc, AdminState>(
    'emits [StudentOperationSuccess] when UpdateStudentEvent is added and succeeds',
    build: () {
      when(
        () => mockStudentWriter.updateStudent(any()),
      ).thenAnswer((_) async {});
      return bloc;
    },
    act: (bloc) => bloc.add(UpdateStudentEvent(tStudent)),
    expect: () => [
      StudentOperationSuccess(message: 'Student updated successfully'),
    ],
    verify: (_) {
      verify(() => mockStudentWriter.updateStudent(tStudent)).called(1);
    },
  );

  blocTest<StudentManagementBloc, AdminState>(
    'emits [StudentOperationSuccess] when DeleteStudentEvent is added and succeeds',
    build: () {
      when(
        () => mockStudentWriter.deleteStudent(any()),
      ).thenAnswer((_) async {});
      return bloc;
    },
    act: (bloc) => bloc.add(DeleteStudentEvent('1')),
    expect: () => [
      StudentOperationSuccess(message: 'Student deleted successfully'),
    ],
    verify: (_) {
      verify(() => mockStudentWriter.deleteStudent('1')).called(1);
    },
  );
}
