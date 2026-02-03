import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';

class GetAdminProfile {
  final AdminRepository repository;
  GetAdminProfile(this.repository);
  Future<Teacher> call() => repository.getAdminProfile();
}
