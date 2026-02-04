import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';

class AddStudent {
  final AdminRepository repository;
  AddStudent(this.repository);
  Future<void> call(Student student) => repository.addStudent(student);
}
