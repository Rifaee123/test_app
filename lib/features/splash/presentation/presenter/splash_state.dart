import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {
  final String role;
  final String userId;
  final String token;

  SplashAuthenticated({
    required this.role,
    required this.userId,
    required this.token,
  });

  @override
  List<Object?> get props => [role, userId, token];
}

class SplashUnauthenticated extends SplashState {}
