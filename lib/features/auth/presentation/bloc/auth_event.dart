import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String studentId;
  final String password;

  const LoginRequested(this.studentId, this.password);

  @override
  List<Object> get props => [studentId, password];
}

class LogoutRequested extends AuthEvent {}
