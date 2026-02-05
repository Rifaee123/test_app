import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/features/admin/domain/validation/student_validator.dart';

void main() {
  group('validateName', () {
    test('should return error when name is empty', () {
      final result = StudentValidator.validateName('', 'Name');
      expect(result, 'Name cannot be empty');
    });

    test('should return error when name is too short', () {
      final result = StudentValidator.validateName('Al', 'Name');
      expect(result, 'Name must be at least 3 characters');
    });

    test('should return null when name is valid', () {
      final result = StudentValidator.validateName('Alex', 'Name');
      expect(result, null);
    });
  });

  group('validateDateOfBirth', () {
    test('should return error when date is empty', () {
      final result = StudentValidator.validateDateOfBirth('');
      expect(result, 'Date of Birth is required');
    });

    test('should return error when format is invalid', () {
      final result = StudentValidator.validateDateOfBirth('01-01-2000');
      expect(result, 'Enter valid date (YYYY-MM-DD)');
    });

    test('should return null when format is valid', () {
      final result = StudentValidator.validateDateOfBirth('2000-01-01');
      expect(result, null);
    });
  });

  group('validatePhone', () {
    test('should return error when phone is empty', () {
      final result = StudentValidator.validatePhone('');
      expect(result, 'Phone number is required');
    });

    test('should return error when phone length is incorrect', () {
      final result = StudentValidator.validatePhone('123');
      expect(result, 'Phone number must be exactly 10 digits');
    });

    test('should return error when phone contains non-digits', () {
      final result = StudentValidator.validatePhone('123456789a');
      expect(result, 'Phone number must contain only digits');
    });

    test('should return null when phone is valid', () {
      final result = StudentValidator.validatePhone('1234567890');
      expect(result, null);
    });
  });
}
