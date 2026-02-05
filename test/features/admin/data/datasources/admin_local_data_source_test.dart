import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/features/admin/data/datasources/admin_local_data_source.dart';
import 'package:test_app/core/entities/teacher.dart';

void main() {
  late AdminLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = AdminLocalDataSourceImpl();
  });

  group('getAdminProfile', () {
    test('should return Teacher object', () async {
      final result = await dataSource.getAdminProfile();

      expect(result, isA<Teacher>());
      expect(result.name, 'Dr. Sarah Wilson');
    });
  });
}
