import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';

import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/core/services/token_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkService _networkService;
  final TokenService _tokenService;

  AuthRepositoryImpl(this._networkService, this._tokenService);

  @override
  Future<Result<User?>> login(String id, String password) async {
    final result = await _networkService.post(
      '/login',
      data: {'username': id, 'password': password, 'role': 'STUDENT'},
    );

    // If login is successful, the response data contains the JWT
    // Based on standard implementation, it might be a direct string or { "token": "..." }
    if (result.isSuccess) {
      final data = result.getOrNull();
      String? token;

      if (data is String) {
        token = data;
      } else if (data is Map<String, dynamic>) {
        token = data['token'] as String? ?? data['jwt'] as String?;
      }

      if (token != null) {
        await _tokenService.saveToken(token);
      }
    }

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
          dateOfBirth: '2010-05-23',
          parentName: 'Jane Doe',
          parentPhone: '9876543210',
          division: 'A',
          subjects: ['English', 'Maths', 'Social', 'Malayalam'],
          phone: '+1 234 567 890',
          address: '123 Education Lane, Tech City',
          semester: '6th Semester',
          attendance: 85.5,
          averageMarks: 78.4,
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
