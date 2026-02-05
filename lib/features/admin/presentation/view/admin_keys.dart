import 'package:flutter/material.dart';

class AdminKeys {
  // Pages
  static const Key adminHomeView = ValueKey('adminHomeView');
  static const Key studentFormView = ValueKey('studentFormView');
  static const Key studentDetailView = ValueKey('studentDetailView');

  // Home Page Elements
  static const Key welcomeHeader = ValueKey('welcomeHeader');
  static const Key statCardActiveStudents = ValueKey('statCardActiveStudents');
  static const Key addStudentBtn = ValueKey('addStudentBtn');
  static const Key studentList = ValueKey('studentList');

  // Student Item Elements (Suffix with ID)
  static String studentItem(String id) => 'studentItem_$id';
  static String editStudentBtn(String id) => 'editStudentBtn_$id';
  static String deleteStudentBtn(String id) => 'deleteStudentBtn_$id';

  // Student Form Elements
  static const Key studentNameInput = ValueKey('studentNameInput');
  static const Key studentGradeInput = ValueKey('studentGradeInput');
  static const Key studentDobInput = ValueKey('studentDobInput');
  static const Key studentParentNameInput = ValueKey('studentParentNameInput');
  static const Key studentParentPhoneInput = ValueKey(
    'studentParentPhoneInput',
  );
  static const Key saveStudentBtn = ValueKey('saveStudentBtn');
  static const Key cancelFormBtn = ValueKey('cancelFormBtn');

  // Student Detail Elements
  static const Key studentDetailCard = ValueKey('studentDetailCard');
  static const Key backButton = ValueKey('backButton');
}
