import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:test_app/features/admin/presentation/router/admin_router.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/core/utils/responsive_utils.dart';
import 'package:test_app/features/admin/presentation/pages/widgets/admin_stat_card.dart';
import 'package:test_app/features/admin/presentation/pages/widgets/admin_student_card.dart';
import 'package:test_app/features/admin/presentation/pages/widgets/admin_welcome_header.dart';
import 'package:test_app/features/admin/presentation/pages/widgets/admin_section_header.dart';

import 'package:test_app/features/admin/presentation/pages/widgets/admin_shimmer_widgets.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return _buildLoadingState(context);
          } else if (state is AdminLoaded) {
            return CustomScrollView(
              slivers: [
                _buildAppBar(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(context.adaptiveWidth(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdminWelcomeHeader(teacher: state.teacher),
                        SizedBox(height: 6.h),
                        _buildStatsGrid(state.students),
                        SizedBox(height: 8.h),
                        AdminSectionHeader(
                          title: 'Students Management',
                          onAddPressed: () =>
                              AdminRouter.navigateToStudentForm(context),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.adaptiveWidth(6),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return AdminStudentCard(student: state.students[index]);
                    }, childCount: state.students.length),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 8.h)),
              ],
            );
          } else if (state is AdminError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Initializing...'));
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 45.h,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Admin Portal',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10.sp,
          ),
        ),
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 8.w, bottom: 6.h),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 14.sp,
          ),
        ),
        CircleAvatar(
          radius: 8,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.white, size: 10.sp),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildStatsGrid(List<Student> students) {
    return Row(
      children: [
        Expanded(
          child: AdminStatCard(
            title: 'Total Students',
            value: students.length.toString(),
            icon: Icons.people_alt_outlined,
            color: Colors.indigo,
          ),
        ),
        SizedBox(width: 8.w),
        const Spacer(flex: 2),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(context.adaptiveWidth(6)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminShimmerWelcomeHeader(),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    const Expanded(child: AdminShimmerStatCard()),
                    SizedBox(width: 8.w),
                    const Spacer(flex: 2),
                  ],
                ),
                SizedBox(height: 8.h),
                const AdminShimmerStudentCard(), // For section header area
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: context.adaptiveWidth(6)),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return const AdminShimmerStudentCard();
            }, childCount: 5),
          ),
        ),
      ],
    );
  }
}
