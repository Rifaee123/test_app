import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/admin/data/models/student_model.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:test_app/features/admin/data/repositories/admin_api_constants.dart';

import 'package:test_app/features/admin/data/datasources/admin_local_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final NetworkService _networkService;
  final AdminLocalDataSource _localDataSource;

  AdminRepositoryImpl(this._networkService, this._localDataSource);

  @override
  Future<User> getAdminProfile() async {
    return _localDataSource.getAdminProfile();
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
    final model = StudentModel(
      id: student.id,
      name: student.name,
      email: student.email,
      parentPhone: student.parentPhone,
      address: student.address,
      semester: student.semester,
      attendance: student.attendance,
      averageMarks: student.averageMarks,
      parentName: student.parentName,
      division: student.division,
      dateOfBirth: student.dateOfBirth,
      subjects: student.subjects,
    );

    final result = await _networkService.post(
      AdminApiConstants.students,
      data: model.toApiJson(),
    );

    result.fold((exception) => throw exception, (data) => null);
  }

  @override
  Future<void> updateStudent(Student student) async {
    final model = StudentModel(
      id: student.id,
      name: student.name,
      email: student.email,
      parentPhone: student.parentPhone,
      address: student.address,
      semester: student.semester,
      attendance: student.attendance,
      averageMarks: student.averageMarks,
      parentName: student.parentName,
      division: student.division,
      dateOfBirth: student.dateOfBirth,
      subjects: student.subjects,
    );

    final result = await _networkService.put(
      AdminApiConstants.studentDetail(student.id),
      data: model.toApiJson(),
    );

    result.fold((exception) => throw exception, (data) => null);
  }

  @override
  Future<void> deleteStudent(String studentId) async {
    final result = await _networkService.delete(
      AdminApiConstants.studentDetail(studentId),
    );

    result.fold((exception) => throw exception, (data) => null);
  }
}
