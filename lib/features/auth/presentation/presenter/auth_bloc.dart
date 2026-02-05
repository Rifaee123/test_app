import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/auth/domain/value_objects/admin_id.dart';
import 'package:test_app/features/auth/domain/value_objects/auth_id.dart';
import 'package:test_app/features/auth/domain/value_objects/password.dart';
import 'package:test_app/features/auth/domain/value_objects/student_id.dart';
import 'package:test_app/features/auth/presentation/interactor/auth_interactor.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthInteractor interactor;

  AuthBloc(this.interactor) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<NavigateToLoginRequested>(_onNavigateToLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onNavigateToLoginRequested(
    NavigateToLoginRequested event,
    Emitter<AuthState> emit,
  ) {
    interactor.navigateToLogin(isAdmin: event.isAdmin);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Determine role based on isAdmin flag
      final String role = event.isAdmin ? 'ADMIN' : 'STUDENT';

      // Create appropriate AuthId based on isAdmin flag
      final AuthId authId;
      if (event.isAdmin) {
        authId = AdminId.create(event.studentId);
      } else {
        authId = StudentId.create(event.studentId);
      }
      final password = Password.create(event.password);

      // Execute login with role parameter
      final result = await interactor.executeLogin(
        authId: authId,
        password: password,
        role: role,
      );

      // Handle result using the when() method
      result.when(
        onSuccess: (user) {
          if (user != null) {
            emit(AuthAuthenticated(user));
            // Navigation is handled by Interactor on success
          } else {
            emit(const AuthError('Invalid Credentials'));
          }
        },
        onFailure: (exception) {
          emit(AuthError(exception.message));
        },
      );
    } catch (e) {
      if (e is ArgumentError) {
        emit(AuthError(e.message));
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await interactor.executeLogout();
    emit(AuthUnauthenticated());
  }
}
