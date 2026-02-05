import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/test_ids.dart';
import 'subject_card.dart';

class SubjectList extends StatelessWidget {
  final List<String> subjects;

  const SubjectList({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return Container(
        height: 120.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'No subjects registered',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return SizedBox(
      height: 130.h,
      child: ListView.builder(
        key: const ValueKey(TestIds.subjectList),
        scrollDirection: Axis.horizontal,
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return SubjectCard(
            key: ValueKey('${TestIds.subjectCard}_$index'),
            subject: subjects[index],
          );
        },
      ),
    );
  }
}
