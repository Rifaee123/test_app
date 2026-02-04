import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/student/domain/usecases/get_student_profile_usecase.dart';

/// Interactor for student-related high-level operations
class StudentInteractor {
  final GetStudentProfileUseCase _getStudentProfileUseCase;

  StudentInteractor(this._getStudentProfileUseCase);

  Future<Result<Student>> fetchProfile(String studentId) {
    return _getStudentProfileUseCase.execute(studentId);
  }
}
