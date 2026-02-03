import 'package:test_app/core/entities/user.dart';

class Student extends User {
  // id, name, email are in User base class
  final String? phone;
  final String? address;
  final String semester;
  final double attendance;
  final double averageMarks;

  const Student({
    required String id,
    required String name,
    required String email,
    this.phone,
    this.address,
    required this.semester,
    required this.attendance,
    required this.averageMarks,
  }) : super(id: id, name: name, email: email);

  @override
  List<Object?> get props => [
    ...super.props,
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
