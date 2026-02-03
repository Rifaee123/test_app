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

  const Student({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.semester,
    required this.attendance,
    required this.averageMarks,
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
  ];

  Student copyWith({String? name, String? phone, String? address}) {
    return Student(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      semester: semester,
      attendance: attendance,
      averageMarks: averageMarks,
    );
  }
}
