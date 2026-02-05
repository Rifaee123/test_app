import 'package:flutter/foundation.dart';

class CoursesKeys {
  static const Key coursesPage = ValueKey('coursesPage');
  static const Key courseList = ValueKey('courseList');
  static const Key backButton = ValueKey('coursesBackButton');
  static String courseItem(int index) => 'courseItem_$index';
}
