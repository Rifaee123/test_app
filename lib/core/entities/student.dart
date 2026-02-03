import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String semester;
  final double attendance;
  final double averageMarks;
  final String parentName;
  final String division;

  const Student({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.semester,
    required this.attendance,
    required this.averageMarks,
    required this.parentName,
    required this.division,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    address,
    semester,
    attendance,
    averageMarks,
    parentName,
    division,
  ];

  Student copyWith({
    String? name,
    String? phone,
    String? address,
    String? parentName,
    String? division,
  }) {
    return Student(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      semester: semester,
      attendance: attendance,
      averageMarks: averageMarks,
      parentName: parentName ?? this.parentName,
      division: division ?? this.division,
    );
  }
}
