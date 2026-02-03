import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Student?> login(String email, String password) async {
    // Mock delay
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'STU1001' && password == '123456') {
      return const Student(
        id: 'STU1001',
        name: 'John Doe',
        email: 'john.doe@edu.com',
        phone: '+1 234 567 890',
        address: '123 Education Lane, Tech City',
        semester: '6th Semester',
        attendance: 85.5,
        averageMarks: 78.4,
      );
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
