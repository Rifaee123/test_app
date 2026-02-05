import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';

class GetStudents {
  final IStudentRepositoryReader repository;
  GetStudents(this.repository);
  Future<List<Student>> call() => repository.getStudents();
}
