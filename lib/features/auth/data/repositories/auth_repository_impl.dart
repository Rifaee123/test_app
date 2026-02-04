import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';

import 'package:test_app/core/network/network_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkService _networkService;

  AuthRepositoryImpl(this._networkService);

  @override
  Future<Result<User?>> login(String id, String password) async {
    // Simulate network call (ignoring result for mock purposes)
    await _networkService.post(
      '/login',
      data: {'id': id, 'password': password},
    );

    // For now, we are keeping the mock logic but simulating a network request delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real scenario, we would use the network response to create the user
    // Example:
    // final result = await _networkService.post('/login', data: {...});
    // return result.map((data) => User.fromJson(data));

    // Mock authentication logic
    if (id == 'STU1001' && password == '123456') {
      return Result.success(
        const Student(
          id: 'STU1001',
          name: 'John Doe',
          email: 'john.doe@edu.com',
          address: '123 Education Lane, Tech City',
          semester: '6th Semester',
          attendance: 85.5,
          averageMarks: 78.4,
          parentName: 'Rakhav',
          parentPhone: '9876543210',
          division: 'A',
          dateOfBirth: '2010-01-01',
          subjects: ['English', 'Maths'],
        ),
      );
    }

    // Return null for invalid credentials (wrapped in Success)
    return Result.success(null);
  }

  @override
  Future<Result<void>> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(null);
  }
}
