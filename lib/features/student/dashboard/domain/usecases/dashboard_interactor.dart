import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';

abstract class IDashboardInteractor {
  Future<Student> refreshStudentData(String studentId);
}

class DashboardInteractor implements IDashboardInteractor {
  final IStudentRepositoryReader _studentRepository;

  DashboardInteractor(this._studentRepository);

  @override
  Future<Student> refreshStudentData(String studentId) async {
    return await _studentRepository.getStudentById(studentId);
  }
}
