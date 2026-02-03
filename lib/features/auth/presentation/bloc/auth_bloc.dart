import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/auth/domain/usecases/auth_interactor.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthInteractor interactor;

  AuthBloc(this.interactor) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final student = await interactor.executeLogin(
        event.studentId,
        event.password,
      );
      if (student != null) {
        emit(AuthAuthenticated(student));
      } else {
        emit(const AuthError('Invalid Student ID or Password'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await interactor.repository.logout();
    emit(AuthUnauthenticated());
  }
}
