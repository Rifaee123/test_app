import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/core/network/exceptions/network_exception.dart';
import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/admin/data/datasources/admin_local_data_source.dart';
import 'package:test_app/features/admin/data/models/student_model.dart';
import 'package:test_app/features/admin/data/repositories/admin_api_constants.dart';
import 'package:test_app/features/admin/data/repositories/admin_repository_impl.dart';

class MockNetworkService extends Mock implements NetworkService {}

class MockAdminLocalDataSource extends Mock implements AdminLocalDataSource {}

void main() {
  late AdminRepositoryImpl repository;
  late MockNetworkService mockNetworkService;
  late MockAdminLocalDataSource mockLocalDataSource;

  setUp(() {
    mockNetworkService = MockNetworkService();
    mockLocalDataSource = MockAdminLocalDataSource();
    repository = AdminRepositoryImpl(mockNetworkService, mockLocalDataSource);
  });

  const tStudentModel = StudentModel(
    id: '1',
    name: 'Test',
    email: 'test@test.com',
    subjects: [],
  );

  final tStudent = tStudentModel.toEntity();

  group('getStudents', () {
    test(
      'should return list of students when call to network is successful',
      () async {
        // arrange
        final tList = [tStudentModel.toJson()];
        when(
          () => mockNetworkService.get(any()),
        ).thenAnswer((_) async => Result.success(tList));

        // act
        final result = await repository.getStudents();

        // assert
        verify(() => mockNetworkService.get(AdminApiConstants.students));
        expect(result, isA<List<Student>>());
        expect(result.length, 1);
        expect(result.first.id, tStudent.id);
      },
    );

    test(
      'should throw exception when call to network is unsuccessful',
      () async {
        // arrange
        const tException = ServerException(message: 'Error');
        when(
          () => mockNetworkService.get(any()),
        ).thenAnswer((_) async => Result.failure(tException));

        // act
        final call = repository.getStudents;

        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getStudentById', () {
    const tId = '1';

    test('should return student when call to network is successful', () async {
      // arrange
      when(
        () => mockNetworkService.get(any()),
      ).thenAnswer((_) async => Result.success(tStudentModel.toJson()));

      // act
      final result = await repository.getStudentById(tId);

      // assert
      verify(
        () => mockNetworkService.get(AdminApiConstants.studentDetail(tId)),
      );
      expect(result, tStudent);
    });
  });

  group('addStudent', () {
    setUpAll(() {
      registerFallbackValue(tStudentModel.toApiJson());
    });

    test('should call network service with correct data', () async {
      // arrange
      when(
        () => mockNetworkService.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => Result.success(null));

      // act
      await repository.addStudent(tStudent);

      // assert
      verify(
        () => mockNetworkService.post(
          AdminApiConstants.students,
          data: any(named: 'data'),
        ),
      ).called(1);
    });
  });

  group('updateStudent', () {
    test('should call network service with correct data', () async {
      // arrange
      when(
        () => mockNetworkService.put(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => Result.success(null));

      // act
      await repository.updateStudent(tStudent);

      // assert
      verify(
        () => mockNetworkService.put(
          AdminApiConstants.studentDetail(tStudent.id),
          data: any(named: 'data'),
        ),
      ).called(1);
    });
  });

  group('deleteStudent', () {
    const tId = '1';

    test('should call network service with correct id', () async {
      // arrange
      when(
        () => mockNetworkService.delete(any()),
      ).thenAnswer((_) async => Result.success(null));

      // act
      await repository.deleteStudent(tId);

      // assert
      verify(
        () => mockNetworkService.delete(AdminApiConstants.studentDetail(tId)),
      ).called(1);
    });
  });

  group('getAdminProfile', () {
    const tTeacher = Teacher(
      id: '1',
      name: 'Teacher',
      email: 't@t.com',
      department: 'Science',
      subject: 'Math',
    );

    test('should return user from local data source', () async {
      // arrange
      when(
        () => mockLocalDataSource.getAdminProfile(),
      ).thenAnswer((_) async => tTeacher);

      // act
      final result = await repository.getAdminProfile();

      // assert
      verify(() => mockLocalDataSource.getAdminProfile());
      expect(result, tTeacher);
    });
  });
}
