import 'package:test_app/core/entities/teacher.dart';

abstract class IProfileInteractor {
  Future<Teacher> getProfile();
}
