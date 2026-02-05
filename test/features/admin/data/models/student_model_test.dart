import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/data/models/student_model.dart';

void main() {
  const tStudentModel = StudentModel(
    id: '1',
    name: 'Test Student',
    email: 'test@example.com',
    token: 'token',
    phone: '1234567890',
    parentPhone: '0987654321',
    address: 'Test Address',
    semester: '1',
    attendance: 80.0,
    averageMarks: 90.0,
    parentName: 'Test Parent',
    division: 'A',
    dateOfBirth: '2000-01-01',
    subjects: ['Math', 'Science'],
  );

  test('should be a subclass of Student entity', () async {
    expect(tStudentModel, isA<Student>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () async {
      final Map<String, dynamic> jsonMap = {
        'studentId': '1',
        'name': 'Test Student',
        'email': 'test@example.com',
        'parentPhone': '0987654321',
        'address': 'Test Address',
        'semester': '1',
        'attendance': 80.0,
        'averageMarks': 90.0,
        'parentName': 'Test Parent',
        'division': 'A',
        'dateOfBirth': '2000-01-01',
        'subjects': ['Math', 'Science'],
      };

      final result = StudentModel.fromJson(jsonMap);

      expect(result.id, tStudentModel.id);
      expect(result.name, tStudentModel.name);
      expect(result.email, tStudentModel.email);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tStudentModel.toJson();

      final expectedMap = {
        'studentId': '1',
        'name': 'Test Student',
        'email': 'test@example.com',
        'dateOfBirth': '2000-01-01',
        'parentName': 'Test Parent',
        'parentPhone': '0987654321',
        'division': 'A',
        'subjects': ['Math', 'Science'],
      };

      expect(result, expectedMap);
    });
  });

  group('toApiJson', () {
    test('should return a API JSON map containing the proper data', () async {
      final result = tStudentModel.toApiJson();

      final expectedMap = {
        'name': 'Test Student',
        'dateOfBirth': '2000-01-01',
        'parentName': 'Test Parent',
        'parentPhone': '0987654321',
        'division': 'A',
      };

      expect(result, expectedMap);
    });
  });
}
