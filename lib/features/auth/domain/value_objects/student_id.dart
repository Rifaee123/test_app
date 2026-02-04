import 'package:equatable/equatable.dart';

import 'package:test_app/features/auth/domain/value_objects/auth_id.dart';

class StudentId extends Equatable implements AuthId {
  final String value;

  const StudentId(this.value);

  factory StudentId.create(String value) {
    if (value.isEmpty) {
      throw ArgumentError('Student ID cannot be empty');
    }
    return StudentId(value);
  }

  @override
  List<Object> get props => [value];

  @override
  String toString() => value;

  // Optional: Add validation factory methods here
}
