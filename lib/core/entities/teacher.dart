import 'package:equatable/equatable.dart';

class Teacher extends Equatable {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String department;
  final String? profileImageUrl;

  const Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.department,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    subject,
    department,
    profileImageUrl,
  ];
}
