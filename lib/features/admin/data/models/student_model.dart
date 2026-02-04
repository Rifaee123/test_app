import 'package:test_app/core/entities/student.dart';

class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.name,
    super.email = '',
    super.parentPhone,
    super.address,
    super.semester,
    super.attendance,
    super.averageMarks,
    required super.parentName,
    required super.division,
    required super.dateOfBirth,
    required super.subjects,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['studentId'] as String,
      name: json['name'] as String,
      email: '', // Not provided by API
      parentPhone: json['parentPhone'] as String?,
      address: null, // Not provided by API
      semester: null, // Not provided by API
      attendance: null, // Not provided by API
      averageMarks: null, // Not provided by API
      parentName: json['parentName'] as String,
      division: json['division'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      subjects: List<String>.from(json['subjects'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': id,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'division': division,
      'subjects': subjects,
    };
  }

  Student toEntity() {
    return Student(
      id: id,
      name: name,
      email: email,
      parentPhone: parentPhone,
      address: address,
      semester: semester,
      attendance: attendance,
      averageMarks: averageMarks,
      parentName: parentName,
      division: division,
      dateOfBirth: dateOfBirth,
      subjects: subjects,
    );
  }
}
