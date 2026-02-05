import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/core/network/exceptions/network_exception.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:test_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:test_app/features/auth/domain/value_objects/student_id.dart';
import 'package:test_app/features/auth/domain/value_objects/password.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  const tStudentIdStr = 'S123';
  const tPasswordStr = 'password123';
  const tRole = 'STUDENT';
  final tAuthId = StudentId.create(tStudentIdStr);
  final tPassword = Password.create(tPasswordStr);

  // Create a concrete mock user since User is abstract
  final tUser = Student(
    id: 'S123',
    name: 'Test Student',
    email: 'test@edu.com',
    token: 'token123',
    dateOfBirth: '2000-01-01',
    parentName: 'Test Parent',
    parentPhone: '1234567890',
    division: 'A',
    subjects: const ['Math'],
  );

  test('should call login on repository with correct params', () async {
    // Arrange
    when(
      () => mockAuthRepository.login(tStudentIdStr, tPasswordStr, tRole),
    ).thenAnswer((_) async => Result.success(tUser));

    // Act
    final result = await loginUseCase.execute(
      authId: tAuthId,
      password: tPassword,
      role: tRole,
    );

    // Assert
    expect(result.isSuccess, true);
    expect(result.getOrThrow(), tUser);
    verify(
      () => mockAuthRepository.login(tStudentIdStr, tPasswordStr, tRole),
    ).called(1);
  });

  test('should return failure when repository returns failure', () async {
    // Arrange
    const tException = UnknownNetworkException(message: 'Login Failed');
    when(
      () => mockAuthRepository.login(tStudentIdStr, tPasswordStr, tRole),
    ).thenAnswer((_) async => Result.failure(tException));

    // Act
    final result = await loginUseCase.execute(
      authId: tAuthId,
      password: tPassword,
      role: tRole,
    );

    // Assert
    expect(result.isFailure, true);
    expect(result.getExceptionOrNull(), tException);
    verify(
      () => mockAuthRepository.login(tStudentIdStr, tPasswordStr, tRole),
    ).called(1);
  });
}
