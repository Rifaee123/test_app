import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/admin/data/models/student_model.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:test_app/features/admin/data/repositories/admin_api_constants.dart';

class AdminRepositoryImpl implements AdminRepository {
  final NetworkService _networkService;

  AdminRepositoryImpl(this._networkService);

  final Teacher _mockTeacher = const Teacher(
    id: 'TCH2001',
    name: 'Dr. Sarah Wilson',
    email: 'sarah.wilson@edu.com',
    subject: 'Computer Science',
    department: 'Engineering',
  );

  @override
  Future<Teacher> getAdminProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTeacher;
  }

  @override
  Future<List<Student>> getStudents() async {
    final result = await _networkService.get(AdminApiConstants.students);

    return result.fold((exception) => throw exception, (data) {
      if (data is List) {
        return data
            .map(
              (json) => StudentModel.fromJson(
                json as Map<String, dynamic>,
              ).toEntity(),
            )
            .toList();
      }
      return [];
    });
  }

  @override
  Future<Student> getStudentById(String id) async {
    final result = await _networkService.get(
      AdminApiConstants.studentDetail(id),
    );

    return result.fold((exception) => throw exception, (data) {
      if (data != null) {
        return StudentModel.fromJson(data as Map<String, dynamic>).toEntity();
      }
      throw Exception('Student not found');
    });
  }

  @override
  Future<void> addStudent(Student student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // No-op for now as we focus on fetching
  }

  @override
  Future<void> updateStudent(Student student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // No-op for now as we focus on fetching
  }

  @override
  Future<void> deleteStudent(String studentId) async {
    final result = await _networkService.delete(
      AdminApiConstants.studentDetail(studentId),
    );

    result.fold((exception) => throw exception, (data) => null);
  }
}
