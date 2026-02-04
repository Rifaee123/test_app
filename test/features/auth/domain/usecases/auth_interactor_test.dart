import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:test_app/features/auth/domain/usecases/auth_interactor.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthInteractor interactor;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    interactor = AuthInteractor(mockRepository);
  });

  const tEmail = 'test@edu.com';
  const tPassword = 'password123';
  const tStudent = Student(
    id: '123',
    name: 'Test Student',
    email: tEmail,
    semester: 'S1',
    division: 'A',
    parentName: 'Parent',
    attendance: 80,
    averageMarks: 85,
  );

  test(
    'should return student from repository when login is successful',
    () async {
      // arrange
      when(
        () => mockRepository.login(tEmail, tPassword),
      ).thenAnswer((_) async => tStudent);

      // act
      final result = await interactor.executeLogin(tEmail, tPassword);

      // assert
      expect(result, tStudent);
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
    },
  );

  test('should return null when login fails', () async {
    // arrange
    when(
      () => mockRepository.login(tEmail, tPassword),
    ).thenAnswer((_) async => null);

    // act
    final result = await interactor.executeLogin(tEmail, tPassword);

    // assert
    expect(result, null);
    verify(() => mockRepository.login(tEmail, tPassword)).called(1);
  });
}
