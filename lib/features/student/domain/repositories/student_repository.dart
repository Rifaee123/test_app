import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/network/result.dart';

/// Repository interface for student-related data
abstract class StudentRepository {
  /// Fetch student profile by ID
  Future<Result<Student>> getStudentProfile(String studentId);
}
