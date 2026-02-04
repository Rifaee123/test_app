import 'package:test_app/core/entities/user.dart';

class Student extends User {
  // id, name, email are in User base class
  final String dateOfBirth;
  final String parentName;
  final String parentPhone;
  final String division;
  final List<String> subjects;
  final String? phone;
  final String? address;
  final String semester;
  final double attendance;
  final double averageMarks;

  const Student({
    required super.id,
    required super.name,
    required super.email,
    required this.dateOfBirth,
    required this.parentName,
    required this.parentPhone,
    required this.division,
    required this.subjects,
    this.phone,
    this.address,
    this.semester = 'S1',
    this.attendance = 0.0,
    this.averageMarks = 0.0,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    dateOfBirth,
    parentName,
    parentPhone,
    division,
    subjects,
    phone,
    address,
    semester,
    attendance,
    averageMarks,
  ];

  Student copyWith({
    String? name,
    String? dateOfBirth,
    String? parentName,
    String? parentPhone,
    String? division,
    List<String>? subjects,
    String? phone,
    String? address,
  }) {
    return Student(
      id: id,
      name: name ?? this.name,
      email: email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      division: division ?? this.division,
      subjects: subjects ?? this.subjects,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      semester: semester,
      attendance: attendance,
      averageMarks: averageMarks,
    );
  }
}
