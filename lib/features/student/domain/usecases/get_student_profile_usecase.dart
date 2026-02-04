import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/student/domain/repositories/student_repository.dart';

/// Use case for fetching a student's profile information
class GetStudentProfileUseCase {
  final StudentRepository _repository;

  GetStudentProfileUseCase(this._repository);

  Future<Result<Student>> execute(String studentId) {
    return _repository.getStudentProfile(studentId);
  }
}
