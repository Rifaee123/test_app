import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/admin.dart';
import 'package:test_app/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:test_app/features/auth/presentation/router/auth_navigation.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final AuthNavigation _navigation;

  SplashBloc(this._checkAuthStatusUseCase, this._navigation)
    : super(SplashInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());
    // Artificial delay for splash effect
    await Future.delayed(const Duration(seconds: 2));

    final status = await _checkAuthStatusUseCase.execute();

    if (status.isAuthenticated &&
        status.role != null &&
        status.userId != null) {
      // Authenticated
      emit(
        SplashAuthenticated(
          role: status.role!,
          userId: status.userId!,
          token: status.token ?? '',
        ),
      );

      // Navigation logic
      if (status.role == 'STUDENT') {
        // Reconstruct minimal Student entity
        final student = Student(
          id: status.userId!,
          name: '', // Placeholder, will be fetched by Dashboard
          email: '',
          token: status.token,
        );
        _navigation.goToHome(student);
      } else if (status.role == 'ADMIN') {
        // Reconstruct minimal Admin entity
        final admin = Admin(
          id: status.userId!,
          name: '',
          email: '',
          token: status.token,
        );
        _navigation.goToHome(admin);
      } else {
        // Unknown role, fallback to login
        _navigation.goToLogin(isAdmin: false);
      }
    } else {
      // Unauthenticated
      emit(SplashUnauthenticated());
      _navigation.goToLanding();
    }
  }
}
