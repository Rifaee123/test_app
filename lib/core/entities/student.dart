import 'package:test_app/core/entities/user.dart';

class Student extends User {
  final String? parentPhone;
  final String? address;
  final String? semester;
  final double? attendance;
  final double? averageMarks;
  final String parentName;
  final String division;
  final String dateOfBirth;
  final List<String> subjects;

  const Student({
    required super.id,
    required super.name,
    super.email = '',
    this.parentPhone,
    this.address,
    this.semester,
    this.attendance,
    this.averageMarks,
    required this.parentName,
    required this.division,
    required this.dateOfBirth,
    required this.subjects,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    parentPhone,
    address,
    semester,
    attendance,
    averageMarks,
    parentName,
    division,
    dateOfBirth,
    subjects,
  ];

  Student copyWith({
    String? name,
    String? parentPhone,
    String? address,
    String? parentName,
    String? division,
    String? dateOfBirth,
    List<String>? subjects,
  }) {
    return Student(
      id: id,
      name: name ?? this.name,
      email: email,
      parentPhone: parentPhone ?? this.parentPhone,
      address: address ?? this.address,
      semester: semester,
      attendance: attendance,
      averageMarks: averageMarks,
      parentName: parentName ?? this.parentName,
      division: division ?? this.division,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      subjects: subjects ?? this.subjects,
    );
  }
}
