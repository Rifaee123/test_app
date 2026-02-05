import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/test_ids.dart';
import 'package:test_app/features/student/dashboard/presentation/presenter/student_dashboard_bloc.dart';
import 'package:test_app/features/student/dashboard/presentation/presenter/student_dashboard_events.dart';
import 'package:test_app/features/student/dashboard/presentation/presenter/student_dashboard_states.dart';
import '../widgets/profile_header.dart';
import '../widgets/subject_list.dart';
import '../widgets/quick_stat_card.dart';

class DashboardPage extends StatelessWidget {
  final Student student;

  const DashboardPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<StudentDashboardBloc>()..add(FetchStudentData(student.id)),
      child: BlocBuilder<StudentDashboardBloc, StudentDashboardState>(
        builder: (context, state) {
          final currentStudent = state is StudentDashboardLoaded
              ? state.student
              : student;

          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              title: Semantics(
                label: TestIds.dashboardTitle,
                child: const Text(
                  'EduTrack Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<StudentDashboardBloc>().add(
                  FetchStudentData(student.id),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(student: currentStudent),
                    SizedBox(height: 24.h),

                    // Dashboard Quick Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuickStatCard(
                          title: 'Attendance',
                          value:
                              '${((currentStudent.attendance ?? 0) * 100).toStringAsFixed(0)}%',
                          icon: Icons.calendar_today_rounded,
                          color: const Color(0xFF10B981),
                          progress: currentStudent.attendance ?? 0,
                        ),
                        QuickStatCard(
                          title: 'Average Marks',
                          value:
                              '${((currentStudent.averageMarks ?? 0) * 100).toStringAsFixed(1)}%',
                          icon: Icons.auto_graph_rounded,
                          color: const Color(0xFFF59E0B),
                          progress: currentStudent.averageMarks ?? 0,
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    Text(
                      'Academic Subjects',
                      key: const ValueKey('academic_subjects_header'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SubjectList(subjects: currentStudent.subjects),

                    if (state is StudentDashboardLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),

                    if (state is StudentDashboardError)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(
                            'Update failed: ${state.message}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
