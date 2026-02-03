import 'package:test_app/core/entities/student.dart';

class DashboardInteractor {
  // Can add backend fetch logic here
  Future<Student> refreshStudentData(Student currentStudent) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return currentStudent; // Mock refresh
  }
}
