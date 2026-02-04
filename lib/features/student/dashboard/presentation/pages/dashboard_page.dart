import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/theme/app_theme.dart';

class DashboardPage extends StatelessWidget {
  final Student student;

  const DashboardPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSidebar(context),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBreadcrumbs(),
            SizedBox(height: 24.h),
            _buildLayout(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text('Student Dashboard'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: AppTheme.darkTextColor),
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppTheme.darkTextColor,
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.mockupPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.mockupPrimary.withValues(alpha: 0.2),
            child: const Icon(Icons.person, size: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.darkSurface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.darkBorder)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.mockupPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.school, color: Colors.white),
                ),
                SizedBox(width: 12.w),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EduTrack',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Academic Mgmt',
                      style: TextStyle(
                        color: AppTheme.darkTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _sidebarItem(Icons.dashboard, 'Dashboard', isActive: true),
          _sidebarItem(Icons.menu_book, 'Curriculum'),
          _sidebarItem(Icons.calendar_month, 'Events'),
          _sidebarItem(Icons.analytics, 'Reports'),
          _sidebarItem(Icons.person, 'Profile'),
          const Spacer(),
          const Divider(),
          _sidebarItem(Icons.logout, 'Logout', color: Colors.redAccent),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _sidebarItem(
    IconData icon,
    String title, {
    bool isActive = false,
    Color? color,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.darkBorder : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? const Border(
                left: BorderSide(color: AppTheme.mockupPrimary, width: 4),
              )
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive
              ? AppTheme.mockupPrimary
              : (color ?? AppTheme.darkTextColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : (color ?? AppTheme.darkTextColor),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Row(
      children: [
        const Text('Home', style: TextStyle(color: AppTheme.darkTextColor)),
        Icon(Icons.chevron_right, size: 16.sp, color: AppTheme.darkTextColor),
        const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLayout(BuildContext context) {
    if (MediaQuery.of(context).size.width > 900) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: _buildStudentProfileCard()),
          SizedBox(width: 32.w),
          Expanded(flex: 3, child: _buildSubjectOverview(context)),
        ],
      );
    } else {
      return Column(
        children: [
          _buildStudentProfileCard(),
          SizedBox(height: 32.h),
          _buildSubjectOverview(context),
        ],
      );
    }
  }

  Widget _buildStudentProfileCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppTheme.mockupPrimary.withValues(alpha: 0.1),
            child: const Icon(
              Icons.person,
              size: 50,
              color: AppTheme.mockupPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            student.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Status: Active',
            style: TextStyle(
              color: AppTheme.mockupPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 24.h),
          _profileDataRow('STUDENT ID', student.id),
          _profileDataRow('GUARDIAN', student.parentName),
          _profileDataRow('GUARDIAN PHONE', student.parentPhone),
          _profileDataRow('ACADEMIC YEAR', '2023-2024'),
          _profileDataRow('CLASS', student.division),
        ],
      ),
    );
  }

  Widget _profileDataRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.darkBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.darkTextColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 4.h),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSubjectOverview(BuildContext context) {
    final subjectList = student.subjects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Subject Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All Schedule',
                style: TextStyle(color: AppTheme.mockupPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: subjectList.length,
          itemBuilder: (context, index) {
            final subName = subjectList[index];
            return _buildSubjectCard(subName);
          },
        ),
      ],
    );
  }

  Widget _buildSubjectCard(String name) {
    // Basic mapping for colors/icons based on name
    IconData icon = Icons.book;
    Color color = AppTheme.mockupPrimary;
    String type = 'General';

    if (name.contains('English') || name.contains('Malayalam')) {
      icon = Icons.translate;
      color = Colors.indigo;
      type = 'Language';
    } else if (name.contains('Maths')) {
      icon = Icons.calculate;
      color = Colors.teal;
      type = 'Maths';
    } else if (name.contains('Social') || name.contains('History')) {
      icon = Icons.public;
      color = Colors.orange;
      type = 'Arts';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.darkBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: const TextStyle(
                    color: AppTheme.darkTextColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _avatarStack(),
                  SizedBox(width: 4.w),
                  const Text(
                    '+12', // Placeholder count
                    style: TextStyle(
                      color: AppTheme.darkTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward,
                color: AppTheme.mockupPrimary,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatarStack() {
    return SizedBox(
      width: 35,
      height: 20,
      child: Stack(
        children: [
          Positioned(left: 0, child: _smallAvatar(Colors.blueGrey)),
          Positioned(left: 10, child: _smallAvatar(Colors.grey)),
        ],
      ),
    );
  }

  Widget _smallAvatar(Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.darkSurface, width: 2),
      ),
    );
  }
}
