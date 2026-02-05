import 'package:flutter/foundation.dart';

class DashboardKeys {
  // Page
  static const Key dashboardPage = ValueKey('dashboardPage');

  // Header
  static const Key profileImage = ValueKey('dashboardProfileImage');
  static const Key welcomeText = ValueKey('dashboardWelcomeText');
  static const Key notificationButton = ValueKey('dashboardNotificationButton');

  // Stats Card
  static const Key attendanceCard = ValueKey('dashboardAttendanceCard');
  static const Key marksCard = ValueKey('dashboardMarksCard');
  static const Key coursesCard = ValueKey('dashboardCoursesCard');

  // Recent Activity
  static const Key recentActivityList = ValueKey('dashboardRecentActivityList');
  static String recentActivityItem(int index) => 'dashboardActivityItem_$index';

  // Bottom Navigation
  static const Key bottomNav = ValueKey('dashboardBottomNav');
  static const Key navHome = ValueKey('dashboardNavHome');
  static const Key navCourses = ValueKey('dashboardNavCourses');
  static const Key navMarks = ValueKey('dashboardNavMarks');
  static const Key navProfile = ValueKey('dashboardNavProfile');
}
