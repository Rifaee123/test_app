import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_presenter.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/core/utils/responsive_utils.dart';
import 'package:test_app/features/admin/presentation/view/widgets/admin_stat_card.dart';
import 'package:test_app/features/admin/presentation/view/widgets/admin_student_card.dart';
import 'package:test_app/features/admin/presentation/view/widgets/admin_welcome_header.dart';
import 'package:test_app/features/admin/presentation/view/widgets/admin_section_header.dart';
import 'package:test_app/features/admin/presentation/view/widgets/admin_shimmer_widgets.dart';

import 'package:test_app/features/admin/presentation/view/admin_keys.dart';

import 'package:test_app/core/entities/admin.dart';

class AdminHomePage extends StatelessWidget {
  final Admin? admin;
  const AdminHomePage({super.key, this.admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AdminKeys.adminHomeView,
      body: BlocBuilder<AdminPresenter, AdminState>(
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
                          testKey: AdminKeys.addStudentBtn,
                          title: 'Students Management',
                          onAddPressed: () => context
                              .read<AdminPresenter>()
                              .router
                              .navigateToStudentForm(context),
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
                    key: AdminKeys.studentList,
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
      expandedHeight: 50.h,
      floating: true,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withAlpha(200),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20.w,
                top: -10.h,
                child: Icon(
                  Icons.admin_panel_settings,
                  size: 60.sp,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          'ADMIN PORTAL',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 9.sp,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 10.w, bottom: 8.h),
      ),
      actions: [
        _AppBarAction(icon: Icons.notifications_rounded, onPressed: () {}),
        _AppBarAction(icon: Icons.person_rounded, onPressed: () {}),
        SizedBox(width: 10.w),
      ],
    );
  }

  Widget _buildStatsGrid(List<Student> students) {
    return Row(
      children: [
        Expanded(
          child: AdminStatCard(
            testKey: AdminKeys.statCardActiveStudents,
            title: 'Active Students',
            value: students.length.toString(),
            icon: Icons.school_rounded,
            color: AppTheme.primaryColor,
          ),
        ),
        SizedBox(width: 10.w),
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

class _AppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _AppBarAction({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(right: 6.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          onPressed: onPressed,
          constraints: BoxConstraints.tightFor(width: 24.w, height: 24.h),
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: Colors.white, size: 14.sp),
        ),
      ),
    );
  }
}
