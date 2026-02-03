import 'package:flutter/material.dart';
import 'package:test_app/core/entities/course.dart';
import 'package:test_app/core/test_ids.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final List<Course> _courses = [
    const Course(
      id: 'CS101',
      name: 'Introduction to AI',
      instructor: 'Dr. Smith',
    ),
    const Course(
      id: 'CS102',
      name: 'Mobile App Development',
      instructor: 'Prof. Garcia',
    ),
    const Course(id: 'CS103', name: 'Cloud Computing', instructor: 'Dr. Gupta'),
  ];

  void _enroll(String courseId) {
    setState(() {
      final index = _courses.indexWhere((c) => c.id == courseId);
      if (index != -1) {
        _courses[index] = _courses[index].copyWith(isEnrolled: true);
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Enrolled successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Courses')),
      body: Semantics(
        label: TestIds.courseList,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _courses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final course = _courses[index];
            return Card(
              child: ListTile(
                title: Text(course.name),
                subtitle: Text('Instructor: ${course.instructor}'),
                trailing: Semantics(
                  label: TestIds.enrollButton,
                  child: ElevatedButton(
                    onPressed: course.isEnrolled
                        ? null
                        : () => _enroll(course.id),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(course.isEnrolled ? 'Enrolled' : 'Enroll'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
