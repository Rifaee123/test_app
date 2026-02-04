import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/features/admin/domain/interactor/profile_interactor.dart';
import 'package:test_app/features/admin/domain/interactor/student_interactor.dart';
import 'package:test_app/features/admin/domain/usecases/add_student.dart';
import 'package:test_app/features/admin/domain/usecases/delete_student.dart';
import 'package:test_app/features/admin/domain/usecases/get_admin_profile.dart';
import 'package:test_app/features/admin/domain/usecases/get_students.dart';
import 'package:test_app/features/admin/domain/usecases/get_student_by_id.dart';
import 'package:test_app/features/admin/domain/usecases/update_student.dart';

abstract class AdminInteractor
    implements IProfileInteractor, IStudentReader, IStudentWriter {}

class AdminInteractorImpl implements AdminInteractor {
  final GetAdminProfile _getAdminProfile;
  final GetStudents _getStudents;
  final GetStudentById _getStudentById;
  final AddStudent _addStudent;
  final UpdateStudent _updateStudent;
  final DeleteStudent _deleteStudent;

  AdminInteractorImpl({
    required GetAdminProfile getAdminProfile,
    required GetStudents getStudents,
    required GetStudentById getStudentById,
    required AddStudent addStudent,
    required UpdateStudent updateStudent,
    required DeleteStudent deleteStudent,
  }) : _getAdminProfile = getAdminProfile,
       _getStudents = getStudents,
       _getStudentById = getStudentById,
       _addStudent = addStudent,
       _updateStudent = updateStudent,
       _deleteStudent = deleteStudent;

  @override
  Future<Teacher> getProfile() => _getAdminProfile();

  @override
  Future<List<Student>> getStudents() => _getStudents();

  @override
  Future<Student> getStudentById(String id) => _getStudentById(id);

  @override
  Future<void> addStudent(Student student) => _addStudent(student);

  @override
  Future<void> updateStudent(Student student) => _updateStudent(student);

  @override
  Future<void> deleteStudent(String id) => _deleteStudent(id);
}
