import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:test_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:test_app/features/auth/domain/usecases/auth_interactor.dart';

class MockAuthInteractor extends Mock implements AuthInteractor {}

void main() {
  late AuthBloc authBloc;
  late MockAuthInteractor mockInteractor;

  setUp(() {
    mockInteractor = MockAuthInteractor();
    authBloc = AuthBloc(mockInteractor);
  });

  const tStudent = Student(
    id: 'ET-2024-089',
    name: 'Alex Johnson',
    email: 'alex@edu.com',
    semester: 'S1',
    division: '10-A',
    parentName: 'Sarah Johnson',
    attendance: 90,
    averageMarks: 88,
  );

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login is successful',
      build: () {
        when(
          () => mockInteractor.executeLogin('alex@edu.com', 'password'),
        ).thenAnswer((_) async => tStudent);
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested('alex@edu.com', 'password')),
      expect: () => [AuthLoading(), AuthAuthenticated(tStudent)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(
          () => mockInteractor.executeLogin('wrong@edu.com', 'password'),
        ).thenAnswer((_) async => null);
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const LoginRequested('wrong@edu.com', 'password')),
      expect: () => [
        AuthLoading(),
        const AuthError('Invalid Student ID or Password'),
      ],
    );
  });
}
