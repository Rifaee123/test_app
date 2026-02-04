import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';

class UpdateStudent {
  final IStudentRepositoryWriter repository;
  UpdateStudent(this.repository);
  Future<void> call(Student student) => repository.updateStudent(student);
}
