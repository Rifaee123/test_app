import 'package:test_app/core/entities/user.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';

class GetAdminProfile {
  final IProfileRepository repository;
  GetAdminProfile(this.repository);
  Future<User> call() => repository.getAdminProfile();
}
