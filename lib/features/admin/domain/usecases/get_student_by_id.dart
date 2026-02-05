import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';

class GetStudentById {
  final IStudentRepositoryReader _repository;

  GetStudentById(this._repository);

  Future<Student> call(String id) async {
    return await _repository.getStudentById(id);
  }
}
