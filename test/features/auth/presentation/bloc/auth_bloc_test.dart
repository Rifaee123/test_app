import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/core/network/exceptions/network_exception.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_event.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_state.dart';
import 'package:test_app/features/auth/presentation/interactor/auth_interactor.dart';
import 'package:test_app/features/auth/domain/value_objects/student_id.dart';
import 'package:test_app/features/auth/domain/value_objects/password.dart';

class MockAuthInteractor extends Mock implements AuthInteractor {}

void main() {
  late AuthBloc authBloc;
  late MockAuthInteractor mockInteractor;

  setUpAll(() {
    registerFallbackValue(StudentId.create('STU1001'));
    registerFallbackValue(Password.create('password'));
  });

  setUp(() {
    mockInteractor = MockAuthInteractor();
    authBloc = AuthBloc(mockInteractor);
  });

  const tStudent = Student(
    id: 'ET-2024-089',
    name: 'Alex Johnson',
    email: 'alex@edu.com',
    dateOfBirth: '2010-05-23',
    parentName: 'Sarah Johnson',
    parentPhone: '9876543210',
    division: '10-A',
    subjects: ['English', 'Maths', 'Social', 'Malayalam'],
    attendance: 90,
    averageMarks: 88,
  );

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login is successful',
      build: () {
        when(
          () => mockInteractor.executeLogin(
            authId: any(named: 'authId'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Result.success(tStudent));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginRequested('alex@edu.com', 'password', isAdmin: false),
      ),
      expect: () => [AuthLoading(), const AuthAuthenticated(tStudent)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(
          () => mockInteractor.executeLogin(
            authId: any(named: 'authId'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const Result.failure(
            ServerException(message: 'Invalid Credentials'),
          ),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginRequested('wrong@edu.com', 'password', isAdmin: false),
      ),
      expect: () => [AuthLoading(), const AuthError('Invalid Credentials')],
    );

    group('NavigateToLoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'calls navigateToLogin on interactor when NavigateToLoginRequested is added',
        build: () {
          return authBloc;
        },
        act: (bloc) => bloc.add(const NavigateToLoginRequested(isAdmin: false)),
        verify: (_) {
          verify(
            () => mockInteractor.navigateToLogin(isAdmin: false),
          ).called(1);
        },
      );
    });
  });
}
