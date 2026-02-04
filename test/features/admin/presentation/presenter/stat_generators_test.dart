import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/admin/presentation/presenter/stat_generators.dart';

void main() {
  const tStudent1 = Student(
    id: '1',
    name: 'S1',
    email: 'e1',
    division: 'A',
    subjects: ['Math', 'Science'],
  );
  const tStudent2 = Student(
    id: '2',
    name: 'S2',
    email: 'e2',
    division: 'B',
    subjects: ['Math'],
  );
  const tStudent3 = Student(
    id: '3',
    name: 'S3',
    email: 'e3',
    division: 'A',
    subjects: [],
  );

  final students = [tStudent1, tStudent2, tStudent3];

  group('ActiveStudentsGenerator', () {
    test('should return correct count', () {
      final generator = ActiveStudentsGenerator();
      final result = generator.generate(students);
      expect(result.value, '3');
      expect(result.title, 'Active Students');
    });
  });

  group('TotalDivisionsGenerator', () {
    test('should return correct count of unique divisions', () {
      final generator = TotalDivisionsGenerator();
      final result = generator.generate(students);
      expect(result.value, '2'); // A and B
      expect(result.title, 'Total Divisions');
    });
  });

  group('AvgSubjectsGenerator', () {
    test('should return correct average', () {
      final generator = AvgSubjectsGenerator();
      final result = generator.generate(students);
      // (2 + 1 + 0) / 3 = 1.0
      expect(result.value, '1.0');
      expect(result.title, 'Avg. Subjects');
    });

    test('should return 0.0 when list is empty', () {
      final generator = AvgSubjectsGenerator();
      final result = generator.generate([]);
      expect(result.value, '0.0');
    });
  });
}
