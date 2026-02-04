import 'package:bloc_test/bloc_test.dart';
import 'package:test_app/core/network/exceptions/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_event.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_state.dart';
import 'package:test_app/features/auth/presentation/interactor/auth_interactor.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/auth/domain/value_objects/auth_id.dart';
import 'package:test_app/features/auth/domain/value_objects/password.dart';
import 'package:test_app/features/auth/domain/value_objects/student_id.dart';

class MockAuthInteractor extends Mock implements IAuthInteractor {}

class FakeAuthId extends Fake implements AuthId {}

class FakePassword extends Fake implements Password {}

void main() {
  late AuthBloc authBloc;
  late MockAuthInteractor mockInteractor;

  setUpAll(() {
    registerFallbackValue(FakeAuthId());
    registerFallbackValue(FakePassword());
  });

  setUp(() {
    mockInteractor = MockAuthInteractor();
    authBloc = AuthBloc(mockInteractor);
  });

  tearDown(() {
    authBloc.close();
  });

  final tStudent = Student(
    id: 'S123',
    name: 'Test',
    email: 'test@edu.com',
    token: 'token',
  );

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    // Test variables
    const tStudentIdStr = 'S123';
    const tPasswordStr = 'password123';
    final tStudentId = StudentId.create(tStudentIdStr);
    final tPassword = Password.create(tPasswordStr);

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when LoginRequested succeeds',
      build: () {
        when(
          () => mockInteractor.executeLogin(
            authId: tStudentId,
            password: tPassword,
            role: 'STUDENT',
          ),
        ).thenAnswer((_) async => Result.success(tStudent));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginRequested(
          studentId: tStudentIdStr,
          password: tPasswordStr,
          isAdmin: false,
        ),
      ),
      expect: () => [AuthLoading(), AuthAuthenticated(tStudent)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when LoginRequested fails',
      build: () {
        when(
          () => mockInteractor.executeLogin(
            authId: tStudentId,
            password: tPassword,
            role: 'STUDENT',
          ),
        ).thenAnswer(
          (_) async =>
              Result.failure(const UnknownNetworkException(message: 'Error')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginRequested(
          studentId: tStudentIdStr,
          password: tPasswordStr,
          isAdmin: false,
        ),
      ),
      expect: () => [AuthLoading(), const AuthError('Error')],
    );
  });
}
