import 'package:equatable/equatable.dart';

abstract class User extends Equatable {
  final String id;
  final String name;
  final String email;

  String get role;
  String? get token;

  const User({required this.id, required this.name, required this.email});

  @override
  List<Object?> get props => [id, name, email];
}
