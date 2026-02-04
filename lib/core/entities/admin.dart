import 'package:test_app/core/entities/user.dart';

class Admin extends User {
  final String department;
  final List<String> permissions;

  const Admin({
    required String id,
    required String name,
    required String email,
    required this.department,
    required this.permissions,
  }) : super(id: id, name: name, email: email);

  @override
  List<Object?> get props => [...super.props, department, permissions];
}
