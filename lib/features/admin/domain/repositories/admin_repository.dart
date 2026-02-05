import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/teacher.dart';

abstract class AdminRepository {
  Future<Teacher> getAdminProfile();
  Future<List<Student>> getStudents();
  Future<void> addStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String studentId);
}
