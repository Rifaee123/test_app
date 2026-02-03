import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';

class DeleteStudent {
  final AdminRepository repository;
  DeleteStudent(this.repository);
  Future<void> call(String id) => repository.deleteStudent(id);
}
