import 'package:test_app/core/entities/student.dart';

abstract class IStudentReader {
  Future<List<Student>> getStudents();
}

abstract class IStudentWriter {
  Future<void> addStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String id);
}
