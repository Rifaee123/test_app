import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/test_ids.dart';
import 'package:test_app/features/attendance/presentation/pages/attendance_page.dart';
import 'package:test_app/features/courses/presentation/pages/courses_page.dart';
import 'package:test_app/features/marks/presentation/pages/marks_page.dart';
import 'package:test_app/features/profile/presentation/pages/profile_page.dart';

class DashboardPage extends StatelessWidget {
  final User student;

  const DashboardPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: TestIds.dashboardTitle,
          child: const Text('EduTrack Dashboard'),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage(student: student)),
            ),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(context),
            SizedBox(height: 24.h),
            _buildQuickStats(context),
            SizedBox(height: 24.h),
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildActionGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, ${student.name}!',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'Academic Portal | ${student.semester}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Attendance',
            value: '${student.attendance}%',
            color: Colors.blueAccent,
            icon: Icons.calendar_today,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _StatCard(
            title: 'Avg. Marks',
            value: '${student.averageMarks}%',
            color: Colors.green,
            icon: Icons.analytics,
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _ActionCard(
          testId: TestIds.attendanceCard,
          title: 'Attendance',
          icon: Icons.check_circle_outline,
          color: Colors.indigo,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AttendancePage()),
          ),
        ),
        _ActionCard(
          testId: TestIds.coursesCard,
          title: 'Courses',
          icon: Icons.book_outlined,
          color: Colors.orange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CoursesPage()),
          ),
        ),
        _ActionCard(
          testId: TestIds.marksCard,
          title: 'Marks',
          icon: Icons.grade_outlined,
          color: Colors.teal,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MarksPage()),
          ),
        ),
        _ActionCard(
          testId: TestIds.editProfileBtn,
          title: 'Profile',
          icon: Icons.person_outline,
          color: Colors.purple,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProfilePage(student: student)),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String testId;
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.testId,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: testId,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
