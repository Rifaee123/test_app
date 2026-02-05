import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/admin.dart';
import 'package:test_app/features/auth/data/models/login_response_dto.dart';

/// Mapper interface for converting LoginResponseModel to User entities
/// Follows Interface Segregation Principle - single focused interface
/// Follows Dependency Inversion Principle - depend on abstraction
abstract class LoginResponseMapper {
  User mapToEntity(LoginResponseModel response);
}

/// Mapper for converting LoginResponseModel to Student entity
/// Follows Single Responsibility Principle - only maps to Student
class StudentLoginMapper implements LoginResponseMapper {
  @override
  User mapToEntity(LoginResponseModel response) {
    return Student(
      id: response.studentId ?? response.username ?? 'unknown',
      name: response.username ?? 'Student',
      email:
          '${response.username ?? 'student'}@edu.com', // Default email pattern
      token: response.token,
      // Required Student-specific fields with defaults (will be loaded later from profile API)
      dateOfBirth: '', // Will be loaded from profile
      parentName: '', // Will be loaded from profile
      parentPhone: '', // Will be loaded from profile
      division: '', // Will be loaded from profile
      subjects: const [], // Will be loaded from profile
      // Optional fields
      semester: '',
      attendance: 0.0,
      averageMarks: 0.0,
      phone: null,
      address: null,
    );
  }
}

/// Mapper for converting LoginResponseModel to Admin entity
/// Follows Single Responsibility Principle - only maps to Admin
class AdminLoginMapper implements LoginResponseMapper {
  @override
  User mapToEntity(LoginResponseModel response) {
    return Admin(
      id: response.studentId ?? response.username ?? 'unknown',
      name: response.username ?? 'Admin',
      email: '${response.username ?? 'admin'}@edu.com', // Default email pattern
      token: response.token,
      // Admin-specific fields will be loaded later from profile API
      department: null,
      permissions: null,
    );
  }
}

/// Factory for providing appropriate mapper based on role
/// Follows Factory Pattern and Strategy Pattern
/// Follows Open/Closed Principle - open for extension (add new roles), closed for modification
class LoginResponseMapperFactory {
  // Private constructor to prevent instantiation
  LoginResponseMapperFactory._();

  /// Returns appropriate mapper based on user role
  static LoginResponseMapper getMapper(String role) {
    switch (role.toUpperCase()) {
      case 'STUDENT':
        return StudentLoginMapper();
      case 'ADMIN':
        return AdminLoginMapper();
      default:
        throw ArgumentError('Unsupported user role: $role');
    }
  }

  /// Convenience method to directly map response to entity
  static User mapResponse(LoginResponseModel response) {
    if (response.role == null) {
      throw ArgumentError('Role is required in login response');
    }
    final mapper = getMapper(response.role!);
    return mapper.mapToEntity(response);
  }
}
