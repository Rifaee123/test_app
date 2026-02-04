import 'package:test_app/core/entities/student.dart';

/// Data Transfer Object for Student Profile API response
class StudentProfileDTO {
  final String studentId;
  final String name;
  final String dateOfBirth;
  final String parentName;
  final String parentPhone;
  final String division;
  final List<String> subjects;

  StudentProfileDTO({
    required this.studentId,
    required this.name,
    required this.dateOfBirth,
    required this.parentName,
    required this.parentPhone,
    required this.division,
    required this.subjects,
  });

  /// Factory constructor to create DTO from JSON
  factory StudentProfileDTO.fromJson(Map<String, dynamic> json) {
    return StudentProfileDTO(
      studentId: json['studentId'] as String,
      name: json['name'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      parentName: json['parentName'] as String,
      parentPhone: json['parentPhone'] as String,
      division: json['division'] as String,
      subjects: (json['subjects'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  /// Convert DTO to Domain Entity
  Student toEntity() {
    return Student(
      id: studentId,
      name: name,
      email: '$studentId@edutrack.com', // Placeholder if email not in response
      dateOfBirth: dateOfBirth,
      parentName: parentName,
      parentPhone: parentPhone,
      division: division,
      subjects: subjects,
    );
  }
}
