import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/core/entities/user.dart';

abstract class AdminLocalDataSource {
  Future<User> getAdminProfile();
}

class AdminLocalDataSourceImpl implements AdminLocalDataSource {
  final Teacher _mockTeacher = const Teacher(
    id: 'TCH2001',
    name: 'Dr. Sarah Wilson',
    email: 'sarah.wilson@edu.com',
    subject: 'Computer Science',
    department: 'Engineering',
  );

  @override
  Future<User> getAdminProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTeacher;
  }
}
