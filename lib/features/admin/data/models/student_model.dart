import 'package:test_app/core/entities/student.dart';

class StudentModel extends Student {
  const StudentModel({
    required String id,
    required String name,
    required String email,
    String? token,
    String? phone,
    String? parentPhone,
    String? address,
    String? semester,
    double? attendance,
    double? averageMarks,
    String? parentName,
    String? division,
    String? dateOfBirth,
    List<String> subjects = const [],
  }) : super(
         id: id,
         name: name,
         email: email,
         token: token,
         phone: phone,
         parentPhone: parentPhone ?? '',
         address: address,
         semester: semester ?? 'S1',
         attendance: attendance ?? 0.0,
         averageMarks: averageMarks ?? 0.0,
         parentName: parentName ?? '',
         division: division ?? '',
         dateOfBirth: dateOfBirth ?? '',
         subjects: subjects,
       );

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['studentId'] as String,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      parentPhone: json['parentPhone'] as String?,
      address: json['address'] as String?,
      semester: json['semester'] as String?,
      attendance: (json['attendance'] as num?)?.toDouble() ?? 0.0,
      averageMarks: (json['averageMarks'] as num?)?.toDouble() ?? 0.0,
      parentName: json['parentName'] as String?,
      division: json['division'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      subjects: List<String>.from(json['subjects'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': id,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'division': division,
      'subjects': subjects,
    };
  }

  /// Returns JSON for creating/updating a student via API
  Map<String, dynamic> toApiJson() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'division': division,
    };
  }

  Student toEntity() {
    return Student(
      id: id,
      name: name,
      email: email,
      token: token,
      phone: phone,
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
