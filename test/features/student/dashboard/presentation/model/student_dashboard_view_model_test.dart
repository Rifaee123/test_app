import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/student/dashboard/presentation/model/student_dashboard_view_model.dart';

void main() {
  group('StudentDashboardViewModel', () {
    final tStudent = Student(
      id: 'student_1',
      name: 'John Doe',
      email: 'john@example.com',
      division: 'A',
      parentName: 'Jane Doe',
      parentPhone: '555-5555', // Added
      dateOfBirth: '2000-01-01', // Added
      semester: 'Fall 2024',
      attendance: 0.85,
      averageMarks: 0.92,
      subjects: ['Math', 'Science'],
    );

    test('fromEntity should correctly map student entity to view model', () {
      // Act
      final viewModel = StudentDashboardViewModel.fromEntity(tStudent);

      // Assert
      expect(viewModel.name, tStudent.name);
      expect(viewModel.id, tStudent.id);
      expect(viewModel.division, tStudent.division);
      expect(viewModel.parentName, tStudent.parentName);
      expect(viewModel.semester, tStudent.semester);
      expect(viewModel.attendancePercentage, '85%');
      expect(viewModel.attendanceProgress, 0.85);
      expect(viewModel.avgMarksPercentage, '92.0%');
      expect(viewModel.avgMarksProgress, 0.92);
      expect(viewModel.subjects, tStudent.subjects);
    });

    test('fromEntity should handle default empty values', () {
      // Arrange
      const tStudentNull = Student(
        id: 'student_2',
        name: 'Jane Smith',
        email: 'jane@example.com',
        subjects: [],
        dateOfBirth: '',
        division: '',
        parentName: '',
        parentPhone: '',
      );

      // Act
      final viewModel = StudentDashboardViewModel.fromEntity(tStudentNull);

      // Assert
      expect(viewModel.division, '');
      expect(viewModel.parentName, '');
      expect(viewModel.semester, 'S1'); // Default from Student constructor
      expect(viewModel.attendancePercentage, '0%');
      expect(viewModel.avgMarksPercentage, '0.0%');
    });

    test('props should contain all fields for equality check', () {
      final vm1 = StudentDashboardViewModel.fromEntity(tStudent);
      final vm2 = StudentDashboardViewModel.fromEntity(tStudent);

      expect(vm1, vm2);
    });
  });
}
