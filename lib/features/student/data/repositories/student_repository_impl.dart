import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/core/network/api_endpoints.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/student/domain/repositories/student_repository.dart';
import 'package:test_app/features/student/data/models/student_profile_dto.dart';

/// Implementation of StudentRepository using NetworkService (Dio)
class StudentRepositoryImpl implements StudentRepository {
  final NetworkService _networkService;

  StudentRepositoryImpl(this._networkService);

  @override
  Future<Result<Student>> getStudentProfile(String studentId) async {
    final result = await _networkService.get(
      ApiEndpoints.studentProfile(studentId),
    );

    return result.map((data) {
      final dto = StudentProfileDTO.fromJson(data as Map<String, dynamic>);
      return dto.toEntity();
    });
  }
}
