import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/features/student/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  const tStudent = Student(
    id: 'ET-2024-089',
    name: 'Alex Johnson',
    email: 'alex@edu.com',
    semester: 'S1',
    division: '10-A',
    parentName: 'Sarah Johnson',
    attendance: 90,
    averageMarks: 88,
  );

  Widget createWidgetUnderTest() {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return const MaterialApp(home: DashboardPage(student: tStudent));
      },
    );
  }

  testWidgets('DashboardPage displays student name and ID', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Alex Johnson'), findsOneWidget);
    expect(find.text('ET-2024-089'), findsOneWidget);
    expect(find.text('GUARDIAN'), findsOneWidget);
    expect(find.text('Sarah Johnson'), findsOneWidget);
  });

  testWidgets('DashboardPage displays subject overview sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Subject Overview'), findsOneWidget);
    expect(find.text('Malayalam'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Physics'), findsOneWidget);
  });
}
