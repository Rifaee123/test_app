import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_presenter.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/core/utils/responsive_utils.dart';
import 'package:test_app/features/admin/presentation/view/widgets/admin_stat_card.dart';
import 'package:test_app/features/admin/presentation/view/widgets/admin_student_card.dart';
import 'package:test_app/features/admin/presentation/view/widgets/admin_welcome_header.dart';
import 'package:test_app/features/admin/presentation/view/widgets/admin_section_header.dart';
import 'package:test_app/features/admin/presentation/view/widgets/admin_shimmer_widgets.dart';

import 'package:test_app/features/admin/presentation/view/admin_keys.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:test_app/core/test_ids.dart';
import 'package:test_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:test_app/features/auth/presentation/router/auth_navigation.dart';

import 'package:test_app/core/entities/admin.dart';

class AdminHomePage extends StatelessWidget {
  final Admin? admin;
  const AdminHomePage({super.key, this.admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AdminKeys.adminHomeView,
      body: BlocBuilder<AdminDashboardBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return _buildLoadingState(context);
          } else if (state is AdminLoaded) {
            final user = admin ?? state.user;
            final students = state.students;
            return CustomScrollView(
              slivers: [
                _buildAppBar(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(context.adaptiveWidth(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdminWelcomeHeader(user: user),
                        SizedBox(height: 6.h),
                        Semantics(
                          identifier: 'admin_stats_grid',
                          label: 'Administration Statistics Grid',
                          child: _buildStatsGrid(state.stats),
                        ),
                        SizedBox(height: 8.h),
                        AdminSectionHeader(
                          testKey: AdminKeys.addStudentBtn,
                          title: 'Students Management',
                          onAddPressed: () async {
                            final shouldRefresh = await context
                                .read<AdminDashboardBloc>()
                                .router
                                .navigateToStudentForm(context);

                            if (shouldRefresh == true && context.mounted) {
                              context.read<AdminDashboardBloc>().add(
                                LoadAdminDataEvent(),
                              );
                            }
                          },
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
                      return AdminStudentCard(student: students[index]);
                    }, childCount: students.length),
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
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
        title: Semantics(
          identifier: AdminKeys.adminPortalTitle,
          label: AdminKeys.adminPortalTitle,
          header: true,
          child: Text(
            'ADMIN PORTAL',
            key: const ValueKey(AdminKeys.adminPortalTitle),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 9.sp,
              letterSpacing: 1.5,
            ),
          ),
        ),
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 10.w, bottom: 8.h),
      ),
      actions: [
        _AppBarAction(
          identifier: 'notifications_button',
          label: 'Notifications Button',
          hint: 'View notifications',
          icon: Icons.notifications_rounded,
          onPressed: () {},
        ),
        _AppBarAction(
          key: const ValueKey(TestIds.logoutButton),
          identifier: TestIds.logoutButton,
          label: 'Logout Button',
          hint: 'Logout from application',
          icon: Icons.logout_rounded,
          onPressed: () async {
            await sl<LogoutUseCase>().execute();
            if (context.mounted) {
              sl<AuthNavigation>().goToLanding();
            }
          },
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  Widget _buildStatsGrid(List<DashboardStat> stats) {
    return Row(
      children: stats.map((stat) {
        final isLast = stats.indexOf(stat) == stats.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 6.w),
            child: AdminStatCard(
              testKey: stat.testKey,
              title: stat.title,
              value: stat.value,
              icon: stat.icon,
              color: stat.color,
            ),
          ),
        );
      }).toList(),
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
  final String label;
  final String hint;
  final String? identifier;

  const _AppBarAction({
    required this.icon,
    required this.onPressed,
    required this.label,
    required this.hint,
    this.identifier,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(right: 6.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Semantics(
          identifier: identifier,
          label: label,
          hint: hint,
          button: true,
          child: IconButton(
            onPressed: onPressed,
            constraints: BoxConstraints.tightFor(width: 24.w, height: 24.h),
            padding: EdgeInsets.zero,
            icon: Icon(icon, color: Colors.white, size: 14.sp),
          ),
        ),
      ),
    );
  }
}
