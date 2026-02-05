import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final Teacher _mockTeacher = const Teacher(
    id: 'TCH2001',
    name: 'Dr. Sarah Wilson',
    email: 'sarah.wilson@edu.com',
    subject: 'Computer Science',
    department: 'Engineering',
  );

  final List<Student> _students = [
    // ... (existing students)
    const Student(
      id: 'STU1001',
      name: 'John Doe',
      email: 'john.doe@edu.com',
      dateOfBirth: '2010-05-15',
      parentName: 'Robert Doe',
      parentPhone: '+1 234 567 899',
      division: 'Division A',
      subjects: ['Mathematics', 'English', 'Science'],
      phone: '+1 234 567 890',
      address: '123 Education Lane, Tech City',
      semester: '6th Semester',
      attendance: 85.5,
      averageMarks: 78.4,
    ),
    const Student(
      id: 'STU1002',
      name: 'Jane Smith',
      email: 'jane.smith@edu.com',
      dateOfBirth: '2011-08-20',
      parentName: 'Sarah Smith',
      parentPhone: '+1 987 654 322',
      division: 'Division B',
      subjects: ['Physics', 'Chemistry', 'Biology'],
      phone: '+1 987 654 321',
      address: '456 Knowledge St, Tech City',
      semester: '4th Semester',
      attendance: 92.0,
      averageMarks: 88.5,
    ),
  ];

  @override
  Future<Teacher> getAdminProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTeacher;
  }

  @override
  Future<List<Student>> getStudents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_students);
  }

  @override
  Future<void> addStudent(Student student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _students.add(student);
  }

  @override
  Future<void> updateStudent(Student student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      _students[index] = student;
    }
  }

  @override
  Future<void> deleteStudent(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _students.removeWhere((s) => s.id == studentId);
  }
}
