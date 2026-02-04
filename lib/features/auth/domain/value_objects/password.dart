import 'package:equatable/equatable.dart';

class Password extends Equatable {
  final String value;

  const Password(this.value);

  factory Password.create(String value) {
    if (value.length < 6) {
      throw ArgumentError('Password must be at least 6 characters long');
    }
    return Password(value);
  }

  @override
  List<Object> get props => [value];

  @override
  String toString() => value; // Be careful logging this!
}
