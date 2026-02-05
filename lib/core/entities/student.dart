import 'package:test_app/core/entities/user.dart';

class Student extends User {
  // id, name, email are in User base class
  final String? token; // Authentication token
  final String? phone;
  final String? parentPhone;
  final String? address;
  final String? semester;
  final double? attendance;
  final double? averageMarks;
  final String? parentName;
  final String? division;
  final String? dateOfBirth;
  final List<String> subjects;

  const Student({
    required String id,
    required String name,
    required String email,
    this.token,
    this.phone,
    this.parentPhone,
    this.address,
    this.semester,
    this.attendance,
    this.averageMarks,
    this.parentName,
    this.division,
    this.dateOfBirth,
    this.subjects = const [],
  }) : super(id: id, name: name, email: email);

  @override
  String get role => 'STUDENT';

  @override
  List<Object?> get props => [
    ...super.props,
    token,
    phone,
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
    String? email,
    String? token,
    String? phone,
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
      email: email ?? this.email,
      token: token ?? this.token,
      phone: phone ?? this.phone,
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
