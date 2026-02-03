import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/auth/domain/value_objects/admin_id.dart';
import 'package:test_app/features/auth/domain/value_objects/auth_id.dart';
import 'package:test_app/features/auth/domain/value_objects/password.dart';
import 'package:test_app/features/auth/domain/value_objects/student_id.dart';
import 'package:test_app/features/auth/presentation/interactor/auth_interactor.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthInteractor interactor;

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
      // Validation Logic moved to Bloc

      // Determine if it's admin or student based on ID format or separate event/flag
      // Ideally, the event could carry an 'isAdmin' flag or we infer it.
      // For now, let's assume if it starts with 'ADM', it's admin.
      // Better approach: Let's assume the UI sends the right ID type?
      // Or we can try to create both and see which one succeeds if formats are distinct.
      // Given the previous UI had isAdmin flag, let's infer from the ID text for now
      // or try to create student first.

      // IMPROVEMENT: The event should probably have the isAdmin flag too if we strictly want
      // to separate them, or we infer from string.
      // Let's infer from string prefix as per Plan/Previous logic roughly.
      // Actually, in the previous UI `isAdmin` was passed to page.
      // Let's try to create StudentId, if it fails try AdminId?
      // Or better: Just check text prefix as a simple heuristic valid for this demo?
      // Or - adding isAdmin to LoginRequested event would be cleanest.
      // Let's modify the event in the next step. for now, let's assume purely based on success of creation.

      // Wait, better yet, let's update LoginRequested in next step to include isAdmin.
      // checking current event definition... it only has id and password.

      final AuthId authId;
      if (event.isAdmin) {
        authId = AdminId.create(event.studentId);
      } else {
        authId = StudentId.create(event.studentId);
      }
      final password = Password.create(event.password);

      final user = await interactor.executeLogin(
        authId: authId,
        password: password,
      );

      if (user != null) {
        emit(AuthAuthenticated(user));
        // Navigation is handled by Interactor on success
      } else {
        emit(const AuthError('Invalid Credentials'));
      }
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
