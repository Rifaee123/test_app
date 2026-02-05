import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_event.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:test_app/features/student/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:test_app/features/student/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:test_app/features/student/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:test_app/features/student/dashboard/presentation/router/dashboard_router.dart';
import 'package:test_app/features/student/dashboard/presentation/pages/dashboard_keys.dart';

class DashboardPage extends StatelessWidget {
  final Student student;

  const DashboardPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<DashboardBloc>()..add(DashboardStarted(student.id)),
      child: Theme(
        data: AppTheme.darkTheme,
        child: Scaffold(
          body: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading || state is DashboardInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DashboardError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () => context.read<DashboardBloc>().add(
                          DashboardStarted(student.id),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is DashboardLoaded) {
                final currentStudent = state.student;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isNarrow = constraints.maxWidth < 1000.w;
                    return Scaffold(
                      key: DashboardKeys.dashboardPage,
                      drawer: isNarrow
                          ? _Sidebar(student: currentStudent)
                          : null,
                      body: Row(
                        children: [
                          // Sidebar (only on large screens)
                          if (!isNarrow) _Sidebar(student: currentStudent),
                          // Main Content
                          Expanded(
                            child: Column(
                              children: [
                                _Header(
                                  student: currentStudent,
                                  isNarrow: isNarrow,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.all(
                                      isNarrow ? 16.w : 32.w,
                                    ),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final bool isCompact =
                                            constraints.maxWidth < 800.w;
                                        final content = [
                                          // Left Column: Student Profile
                                          SizedBox(
                                            width: isCompact
                                                ? double.infinity
                                                : 300.w,
                                            child: _StudentProfileCard(
                                              student: currentStudent,
                                            ),
                                          ),
                                          if (!isCompact)
                                            SizedBox(width: 32.w)
                                          else
                                            SizedBox(height: 32.h),
                                          // Right Column: Subject Overview
                                          Expanded(
                                            flex: isCompact ? 0 : 1,
                                            child: _SubjectOverview(
                                              student: currentStudent,
                                            ),
                                          ),
                                        ];

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildBreadcrumbs(),
                                            SizedBox(height: 32.h),
                                            if (isCompact)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: content,
                                              )
                                            else
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: content,
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Row(
      children: [
        const Text(
          'Home',
          style: TextStyle(color: AppTheme.darkTextColor, fontSize: 14),
        ),
        Icon(
          Icons.chevron_right,
          size: 16,
          color: AppTheme.darkTextColor.withValues(alpha: 0.5),
        ),
        const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  final Student student;
  const _Sidebar({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.w,
      decoration: const BoxDecoration(
        color: AppTheme.darkSurface,
        border: Border(right: BorderSide(color: AppTheme.darkBorder)),
      ),
      child: Column(
        children: [
          // Logo Section
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.mockupPrimary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(Icons.school, color: Colors.white),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EduTrack',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Academic Management',
                      style: TextStyle(
                        color: AppTheme.darkTextColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Navigation Items
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  _SidebarItem(
                    key: DashboardKeys.navHome,
                    icon: Icons.dashboard,
                    label: 'Dashboard',
                    isActive: true,
                    onTap: () {},
                  ),
                  _SidebarItem(
                    key: DashboardKeys.navCourses,
                    icon: Icons.menu_book,
                    label: 'Curriculum',
                    onTap: () {},
                  ),
                  _SidebarItem(
                    // Events doesn't have a specific key yet, maybe skip or add generic
                    icon: Icons.calendar_month,
                    label: 'Events',
                    onTap: () {},
                  ),
                  _SidebarItem(
                    key: DashboardKeys.navMarks,
                    icon: Icons.analytics,
                    label: 'Reports',
                    onTap: () {},
                  ),
                  _SidebarItem(
                    key: DashboardKeys.navProfile,
                    icon: Icons.person,
                    label: 'Profile',
                    onTap: () =>
                        DashboardRouter.navigateToProfile(context, student),
                  ),
                ],
              ),
            ),
          ),
          // Logout Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: _SidebarItem(
              icon: Icons.logout,
              label: 'Logout',
              color: Colors.redAccent,
              onTap: () => context.read<AuthBloc>().add(LogoutRequested()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color? color;
  final VoidCallback onTap;

  const _SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.darkBorder : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: isActive
            ? const Border(
                left: BorderSide(color: AppTheme.mockupPrimary, width: 4),
              )
            : null,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color:
              color ??
              (isActive ? AppTheme.mockupPrimary : AppTheme.darkTextColor),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: color ?? (isActive ? Colors.white : AppTheme.darkTextColor),
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Student student;
  final bool isNarrow;
  const _Header({required this.student, this.isNarrow = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool showSearch = width > 800.w;
        final bool showLabels = width > 500.w;

        return Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(
            horizontal: width > 600.w ? 32.w : 16.w,
          ),
          decoration: const BoxDecoration(
            color: AppTheme.darkSurface,
            border: Border(bottom: BorderSide(color: AppTheme.darkBorder)),
          ),
          child: Row(
            children: [
              if (isNarrow)
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              if (isNarrow) SizedBox(width: 8.w),
              Flexible(
                child: const Text(
                  'Dashboard Overview',
                  key: DashboardKeys.welcomeText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (showSearch) ...[
                SizedBox(width: 16.w),
                const Spacer(),
                // Search Bar
                Flexible(
                  flex: 2,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300.w),
                    height: 40.h,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: AppTheme.darkBorder,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppTheme.darkTextColor,
                          size: 20,
                        ),
                        SizedBox(width: 8.w),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search subjects...',
                              hintStyle: TextStyle(
                                color: AppTheme.darkTextColor,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else
                const Spacer(),
              SizedBox(width: 24.w),
              // Notifications
              _HeaderIconButton(
                key: DashboardKeys.notificationButton,
                icon: Icons.notifications,
                onTap: () {},
                hasBadge: true,
              ),
              SizedBox(width: 16.w),
              // User Profile
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 1.w,
                      height: 32.h,
                      color: AppTheme.darkBorder,
                    ),
                    SizedBox(width: 16.w),
                    if (showLabels)
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              student.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Grade ${student.division}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTheme.darkTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (showLabels) SizedBox(width: 12.w),
                    CircleAvatar(
                      key: DashboardKeys.profileImage,
                      radius: 20.r,
                      backgroundColor: AppTheme.mockupPrimary.withValues(
                        alpha: 0.1,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppTheme.mockupPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const _HeaderIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: AppTheme.darkBorder,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: AppTheme.darkTextColor, size: 22),
            if (hasBadge)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.mockupPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.darkSurface, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StudentProfileCard extends StatelessWidget {
  final Student student;
  const _StudentProfileCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48.r,
            backgroundColor: AppTheme.mockupPrimary.withValues(alpha: 0.1),
            child: Icon(
              Icons.person,
              size: 48.r,
              color: AppTheme.mockupPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            student.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          const Text(
            'Status: Active',
            style: TextStyle(
              color: AppTheme.mockupPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24.h),
          _ProfileInfoItem(label: 'Student ID', value: student.id),
          _ProfileInfoItem(label: 'Guardian', value: student.parentName),
          _ProfileInfoItem(label: 'Academic Year', value: student.semester),
          _ProfileInfoItem(label: 'Class', value: student.division),
        ],
      ),
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.darkBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.darkTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectOverview extends StatelessWidget {
  final Student student;
  const _SubjectOverview({required this.student});

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(
      color: AppTheme.darkTextColor,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Subject Overview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All Schedule'),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        // Header Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(flex: 6, child: Text('SUBJECT', style: headerStyle)),
              Expanded(flex: 2, child: Text('CATEGORY', style: headerStyle)),
              Expanded(
                flex: 1,
                child: Text(
                  'ACTION',
                  style: headerStyle,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        // Subject List
        ListView.separated(
          key: DashboardKeys.recentActivityList,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: student.subjects.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final subject = student.subjects[index];
            return _SubjectCard(
              key: ValueKey(DashboardKeys.recentActivityItem(index)),
              subject: subject,
            );
          },
        ),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String subject;
  const _SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final mapping = _getSubjectMapping(subject);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Row(
        children: [
          // Subject Icon and Name
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: mapping.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(mapping.icon, color: mapping.color, size: 20),
                ),
                SizedBox(width: 16.w),
                Flexible(
                  child: Text(
                    subject,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Category
          Expanded(
            flex: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.darkBorder.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    mapping.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.darkTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward,
                color: AppTheme.mockupPrimary,
                size: 20.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _SubjectMapping _getSubjectMapping(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('malayalam')) {
      return const _SubjectMapping(
        category: 'Language',
        icon: Icons.translate,
        color: Colors.indigoAccent,
      );
    } else if (lowerName.contains('english')) {
      return const _SubjectMapping(
        category: 'Language',
        icon: Icons.description,
        color: Colors.blueAccent,
      );
    } else if (lowerName.contains('hindi')) {
      return const _SubjectMapping(
        category: 'Language',
        icon: Icons.language,
        color: Colors.orangeAccent,
      );
    } else if (lowerName.contains('physics')) {
      return const _SubjectMapping(
        category: 'Science',
        icon: Icons.electric_bolt,
        color: Colors.redAccent,
      );
    } else if (lowerName.contains('chemistry')) {
      return const _SubjectMapping(
        category: 'Science',
        icon: Icons.science,
        color: Colors.tealAccent,
      );
    } else if (lowerName.contains('biology')) {
      return const _SubjectMapping(
        category: 'Science',
        icon: Icons.biotech,
        color: Colors.greenAccent,
      );
    } else if (lowerName.contains('math')) {
      return const _SubjectMapping(
        category: 'Maths',
        icon: Icons.calculate,
        color: AppTheme.mockupPrimary,
      );
    } else if (lowerName.contains('history')) {
      return const _SubjectMapping(
        category: 'Arts',
        icon: Icons.history_edu,
        color: Colors.amberAccent,
      );
    } else if (lowerName.contains('geography')) {
      return const _SubjectMapping(
        category: 'Arts',
        icon: Icons.public,
        color: Colors.pinkAccent,
      );
    }
    return const _SubjectMapping(
      category: 'General',
      icon: Icons.book,
      color: Colors.grey,
    );
  }
}

class _SubjectMapping {
  final String category;
  final IconData icon;
  final Color color;

  const _SubjectMapping({
    required this.category,
    required this.icon,
    required this.color,
  });
}
