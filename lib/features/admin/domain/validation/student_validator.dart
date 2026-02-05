class StudentValidator {
  static const int _minNameLength = 3;
  static const int _phoneLength = 10;
  static final RegExp _dobRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  static final RegExp _phoneRegex = RegExp(r'^[0-9]+$');

  static String? validateName(String? value, String fieldLabel) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldLabel cannot be empty';
    }
    if (value.trim().length < _minNameLength) {
      return '$fieldLabel must be at least $_minNameLength characters';
    }
    return null;
  }

  static String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of Birth is required';
    }
    if (!_dobRegex.hasMatch(value)) {
      return 'Enter valid date (YYYY-MM-DD)';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != _phoneLength) {
      return 'Phone number must be exactly $_phoneLength digits';
    }
    if (!_phoneRegex.hasMatch(value)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }
}
