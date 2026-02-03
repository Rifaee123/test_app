import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/user.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';

import 'package:test_app/core/network/network_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkService _networkService;

  AuthRepositoryImpl(this._networkService);
  @override
  Future<User?> login(String id, String password) async {
    try {
      // Simulate network call
      try {
        await _networkService.post(
          '/login',
          data: {'id': id, 'password': password},
        );
      } catch (_) {
        // Ignore network error for mock purposes
      }

      // For now, we are keeping the mock logic but simulating a network request delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real scenario, we would map 'response' to Student
      if (id == 'STU1001' && password == '123456') {
        return const Student(
          id: 'STU1001',
          name: 'John Doe',
          email: 'john.doe@edu.com',
          phone: '+1 234 567 890',
          address: '123 Education Lane, Tech City',
          semester: '6th Semester',
          attendance: 85.5,
          averageMarks: 78.4,
          parentName: 'Jane Doe',
          division: 'A',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
