import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/core/network/exceptions/network_exception.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:test_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:test_app/features/auth/domain/value_objects/student_id.dart';
import 'package:test_app/features/auth/domain/value_objects/password.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  final tAuthId = StudentId.create('STU1001');
  final tPassword = Password.create('password123');
  const tStudent = Student(
    id: '123',
    name: 'Test Student',
    email: 'test@edu.com',
    dateOfBirth: '2010-05-23',
    parentName: 'Parent',
    parentPhone: '9876543210',
    division: 'A',
    subjects: ['English', 'Maths', 'Social', 'Malayalam'],
    attendance: 80,
    averageMarks: 85,
  );

  test(
    'should return success with student when repository login succeeds',
    () async {
      // arrange
      when(
        () => mockRepository.login(any(), any()),
      ).thenAnswer((_) async => const Result.success(tStudent));

      // act
      final result = await useCase.execute(
        authId: tAuthId,
        password: tPassword,
      );

      // assert
      expect(result, const Result<User?>.success(tStudent));
      verify(
        () => mockRepository.login(tAuthId.value, tPassword.value),
      ).called(1);
    },
  );

  test('should return failure when repository login fails', () async {
    // arrange
    const tException = ServerException(message: 'Invalid Credentials');
    when(
      () => mockRepository.login(any(), any()),
    ).thenAnswer((_) async => const Result.failure(tException));

    // act
    final result = await useCase.execute(authId: tAuthId, password: tPassword);

    // assert
    expect(result, const Result<User?>.failure(tException));
    verify(
      () => mockRepository.login(tAuthId.value, tPassword.value),
    ).called(1);
  });
}
