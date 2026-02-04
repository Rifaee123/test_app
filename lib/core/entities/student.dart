import 'package:test_app/core/entities/user.dart';

class Student extends User {
<<<<<<< HEAD
  final String? parentPhone;
=======
  // id, name, email are in User base class
  final String? token; // Authentication token
  final String? phone;
>>>>>>> 1a07ada0f75be57277965f78d17dbfa68cb81d5c
  final String? address;
  final String? semester;
  final double? attendance;
  final double? averageMarks;
<<<<<<< HEAD
  final String parentName;
  final String division;
  final String dateOfBirth;
  final List<String> subjects;
=======
  final String? parentName;
  final String? division;
>>>>>>> 1a07ada0f75be57277965f78d17dbfa68cb81d5c

  const Student({
    required super.id,
    required super.name,
<<<<<<< HEAD
    super.email = '',
    this.parentPhone,
=======
    required super.email,
    this.token,
    this.phone,
>>>>>>> 1a07ada0f75be57277965f78d17dbfa68cb81d5c
    this.address,
    this.semester,
    this.attendance,
    this.averageMarks,
<<<<<<< HEAD
    required this.parentName,
    required this.division,
    required this.dateOfBirth,
    required this.subjects,
=======
    this.parentName,
    this.division,
>>>>>>> 1a07ada0f75be57277965f78d17dbfa68cb81d5c
  });

  @override
  String get role => 'STUDENT';

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
