import 'package:equatable/equatable.dart';

import 'package:test_app/features/auth/domain/value_objects/auth_id.dart';

class AdminId extends Equatable implements AuthId {
  final String value;

  const AdminId(this.value);

  factory AdminId.create(String value) {
    if (value.isEmpty) {
      throw ArgumentError('Admin ID cannot be empty');
    }
    return AdminId(value);
  }

  @override
  List<Object> get props => [value];

  @override
  String toString() => value;
}
