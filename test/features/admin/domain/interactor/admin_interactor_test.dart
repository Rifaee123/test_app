import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/features/admin/domain/interactor/admin_interactor.dart';
import 'package:test_app/features/admin/domain/usecases/add_student.dart';
import 'package:test_app/features/admin/domain/usecases/delete_student.dart';
import 'package:test_app/features/admin/domain/usecases/get_admin_profile.dart';
import 'package:test_app/features/admin/domain/usecases/get_students.dart';
import 'package:test_app/features/admin/domain/usecases/get_student_by_id.dart';
import 'package:test_app/features/admin/domain/usecases/update_student.dart';

class MockGetAdminProfile extends Mock implements GetAdminProfile {}

class MockGetStudents extends Mock implements GetStudents {}

class MockGetStudentById extends Mock implements GetStudentById {}

class MockAddStudent extends Mock implements AddStudent {}

class MockUpdateStudent extends Mock implements UpdateStudent {}

class MockDeleteStudent extends Mock implements DeleteStudent {}

void main() {
  late AdminInteractorImpl interactor;
  late MockGetAdminProfile mockGetAdminProfile;
  late MockGetStudents mockGetStudents;
  late MockGetStudentById mockGetStudentById;
  late MockAddStudent mockAddStudent;
  late MockUpdateStudent mockUpdateStudent;
  late MockDeleteStudent mockDeleteStudent;

  setUpAll(() {
    registerFallbackValue(
      const Student(
        id: '0',
        name: 'Fallback',
        email: 'f@f.com',
        subjects: [],
        dateOfBirth: '',
        division: '',
        parentName: '',
        parentPhone: '',
      ),
    );
  });

  setUp(() {
    mockGetAdminProfile = MockGetAdminProfile();
    mockGetStudents = MockGetStudents();
    mockGetStudentById = MockGetStudentById();
    mockAddStudent = MockAddStudent();
    mockUpdateStudent = MockUpdateStudent();
    mockDeleteStudent = MockDeleteStudent();

    interactor = AdminInteractorImpl(
      getAdminProfile: mockGetAdminProfile,
      getStudents: mockGetStudents,
      getStudentById: mockGetStudentById,
      addStudent: mockAddStudent,
      updateStudent: mockUpdateStudent,
      deleteStudent: mockDeleteStudent,
    );
  });

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

  const tTeacher = Teacher(
    id: '1',
    name: 'Teacher',
    email: 't@t.com',
    department: 'Science',
    subject: 'Math',
  );

  test('getProfile should call usecase', () async {
    when(() => mockGetAdminProfile()).thenAnswer((_) async => tTeacher);

    final result = await interactor.getProfile();

    expect(result, tTeacher);
    verify(() => mockGetAdminProfile()).called(1);
  });

  test('getStudents should call usecase', () async {
    when(() => mockGetStudents()).thenAnswer((_) async => [tStudent]);

    final result = await interactor.getStudents();

    expect(result, [tStudent]);
    verify(() => mockGetStudents()).called(1);
  });

  test('getStudentById should call usecase', () async {
    when(() => mockGetStudentById(any())).thenAnswer((_) async => tStudent);

    final result = await interactor.getStudentById('1');

    expect(result, tStudent);
    verify(() => mockGetStudentById('1')).called(1);
  });

  test('addStudent should call usecase', () async {
    when(() => mockAddStudent(any())).thenAnswer((_) async {});

    await interactor.addStudent(tStudent);

    verify(() => mockAddStudent(tStudent)).called(1);
  });

  test('updateStudent should call usecase', () async {
    when(() => mockUpdateStudent(any())).thenAnswer((_) async {});

    await interactor.updateStudent(tStudent);

    verify(() => mockUpdateStudent(tStudent)).called(1);
  });

  test('deleteStudent should call usecase', () async {
    when(() => mockDeleteStudent(any())).thenAnswer((_) async {});

    await interactor.deleteStudent('1');

    verify(() => mockDeleteStudent('1')).called(1);
  });
}
