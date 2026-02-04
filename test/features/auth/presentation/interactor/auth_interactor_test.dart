import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:test_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:test_app/features/auth/presentation/interactor/auth_interactor.dart';
import 'package:test_app/features/auth/presentation/router/auth_navigation.dart';
import 'package:test_app/features/auth/domain/value_objects/student_id.dart';
import 'package:test_app/features/auth/domain/value_objects/password.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockAuthNavigation extends Mock implements AuthNavigation {}

class MockUser extends Mock implements User {}

void main() {
  late AuthInteractor interactor;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockAuthNavigation mockNavigation;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockNavigation = MockAuthNavigation();
    interactor = AuthInteractor(
      mockLoginUseCase,
      mockLogoutUseCase,
      mockNavigation,
    );
  });

  const tStudentIdStr = 'S123';
  const tPasswordStr = 'password123';
  final tAuthId = StudentId.create(tStudentIdStr);
  final tPassword = Password.create(tPasswordStr);
  final tUser = Student(id: 'S123', name: 'Test', email: 'test@edu.com');

  test('executeLogin should call usecase and navigate on success', () async {
    // Arrange
    when(
      () => mockLoginUseCase.execute(
        authId: tAuthId,
        password: tPassword,
        role: 'STUDENT',
      ),
    ).thenAnswer((_) async => Result.success(tUser));

    // Act
    await interactor.executeLogin(
      authId: tAuthId,
      password: tPassword,
      role: 'STUDENT',
    );

    // Assert
    verify(
      () => mockLoginUseCase.execute(
        authId: tAuthId,
        password: tPassword,
        role: 'STUDENT',
      ),
    ).called(1);

    verify(() => mockNavigation.goToHome(tUser)).called(1);
  });

  test('navigateToLogin should call navigation', () {
    // Act
    interactor.navigateToLogin(isAdmin: true);

    // Assert
    verify(() => mockNavigation.goToLogin(isAdmin: true)).called(1);
  });
}
