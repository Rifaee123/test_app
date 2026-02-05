import 'package:equatable/equatable.dart';
import 'package:test_app/core/entities/student.dart';

class StudentDashboardViewModel extends Equatable {
  final String name;
  final String id;
  final String division;
  final String parentName;
  final String semester;
  final String attendancePercentage;
  final double attendanceProgress;
  final String avgMarksPercentage;
  final double avgMarksProgress;
  final List<String> subjects;

  const StudentDashboardViewModel({
    required this.name,
    required this.id,
    required this.division,
    required this.parentName,
    required this.semester,
    required this.attendancePercentage,
    required this.attendanceProgress,
    required this.avgMarksPercentage,
    required this.avgMarksProgress,
    required this.subjects,
  });

  factory StudentDashboardViewModel.fromEntity(Student student) {
    return StudentDashboardViewModel(
      name: student.name,
      id: student.id,
      division: student.division,
      parentName: student.parentName,
      semester: student.semester,
      attendancePercentage: '${(student.attendance * 100).toStringAsFixed(0)}%',
      attendanceProgress: student.attendance,
      avgMarksPercentage: '${(student.averageMarks * 100).toStringAsFixed(1)}%',
      avgMarksProgress: student.averageMarks,
      subjects: student.subjects,
    );
  }

  @override
  List<Object?> get props => [
    name,
    id,
    division,
    parentName,
    semester,
    attendancePercentage,
    attendanceProgress,
    avgMarksPercentage,
    avgMarksProgress,
    subjects,
  ];
}
