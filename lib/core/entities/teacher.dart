import 'package:test_app/core/entities/user.dart';

class Teacher extends User {
  final String subject;
  final String department;
  final String? profileImageUrl;

  const Teacher({
    required super.id,
    required super.name,
    required super.email,
    required this.subject,
    required this.department,
    this.profileImageUrl,
  });

  @override
  String get role => 'TEACHER';

  @override
  String? get token => null; // Teachers might have tokens in a real app

  @override
  List<Object?> get props => [
    ...super.props,
    subject,
    department,
    profileImageUrl,
  ];
}
