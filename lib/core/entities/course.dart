import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String name;
  final String instructor;
  final bool isEnrolled;

  const Course({
    required this.id,
    required this.name,
    required this.instructor,
    this.isEnrolled = false,
  });

  @override
  List<Object?> get props => [id, name, instructor, isEnrolled];

  Course copyWith({bool? isEnrolled}) {
    return Course(
      id: id,
      name: name,
      instructor: instructor,
      isEnrolled: isEnrolled ?? this.isEnrolled,
    );
  }
}
