import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:test_app/features/student/dashboard/domain/usecases/dashboard_interactor.dart';

class MockStudentRepository extends Mock implements IStudentRepositoryReader {}

void main() {
  late DashboardInteractor interactor;
  late MockStudentRepository mockRepository;

  setUp(() {
    mockRepository = MockStudentRepository();
    interactor = DashboardInteractor(mockRepository);
  });

  group('DashboardInteractor', () {
    const tStudentId = 'student_1';
    final tStudent = Student(
      id: tStudentId,
      name: 'John Doe',
      email: 'john@example.com',
      subjects: ['Math'],
      dateOfBirth: '2000-01-01',
      division: 'A',
      parentName: 'Parent',
      parentPhone: '555-5555',
    );

    test('refreshStudentData should return student from repository', () async {
      // Arrange
      when(
        () => mockRepository.getStudentById(tStudentId),
      ).thenAnswer((_) async => tStudent);

      // Act
      final result = await interactor.refreshStudentData(tStudentId);

      // Assert
      expect(result, tStudent);
      verify(() => mockRepository.getStudentById(tStudentId)).called(1);
    });

    test(
      'refreshStudentData should throw error when repository fails',
      () async {
        // Arrange
        when(
          () => mockRepository.getStudentById(tStudentId),
        ).thenThrow(Exception('Failed to fetch'));

        // Act & Assert
        expect(
          () => interactor.refreshStudentData(tStudentId),
          throwsA(isA<Exception>()),
        );
        verify(() => mockRepository.getStudentById(tStudentId)).called(1);
      },
    );
  });
}
