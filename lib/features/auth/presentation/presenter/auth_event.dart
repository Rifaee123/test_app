import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String studentId;
  final String password;
  final bool isAdmin;

  const LoginRequested({
    required this.studentId,
    required this.password,
    required this.isAdmin,
  });

  @override
  List<Object> get props => [studentId, password, isAdmin];
}

class LogoutRequested extends AuthEvent {}

class NavigateToLoginRequested extends AuthEvent {
  final bool isAdmin;

  const NavigateToLoginRequested({required this.isAdmin});

  @override
  List<Object> get props => [isAdmin];
}
