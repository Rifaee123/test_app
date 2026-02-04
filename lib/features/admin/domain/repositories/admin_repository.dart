import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/teacher.dart';

abstract class IProfileRepository {
  Future<Teacher> getAdminProfile();
}

abstract class IStudentRepositoryReader {
  Future<List<Student>> getStudents();
  Future<Student> getStudentById(String id);
}

abstract class IStudentRepositoryWriter {
  Future<void> addStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String studentId);
}

abstract class AdminRepository
    implements
        IProfileRepository,
        IStudentRepositoryReader,
        IStudentRepositoryWriter {}
