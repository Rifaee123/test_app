import 'package:flutter/material.dart';

class AdminKeys {
  // Page IDs
  static const String adminHomeViewId = 'admin_home_view';
  static const String studentFormViewId = 'student_form_view';
  static const String studentDetailViewId = 'student_detail_view';

  // Pages (Legacy Keys)
  static const Key adminHomeView = ValueKey(adminHomeViewId);
  static const Key studentFormView = ValueKey(studentFormViewId);
  static const Key studentDetailView = ValueKey(studentDetailViewId);

  // Home Page Elements
  static const String welcomeHeaderId = 'admin_welcome_header';
  static const String statCardActiveStudentsId = 'stat_card_active_students';
  static const String addStudentBtnId = 'add_student_button';
  static const String studentListId = 'admin_student_list';
  static const String adminPortalTitle = 'admin_portal_title';

  static const Key welcomeHeader = ValueKey(welcomeHeaderId);
  static const Key statCardActiveStudents = ValueKey(statCardActiveStudentsId);
  static const Key addStudentBtn = ValueKey(addStudentBtnId);
  static const Key studentList = ValueKey(studentListId);

  // Student Item Elements (Suffix with ID)
  static String studentItem(String id) => 'student_item_$id';
  static String editStudentBtn(String id) => 'edit_student_button_$id';
  static String deleteStudentBtn(String id) => 'delete_student_button_$id';

  // Student Form Elements
  static const String studentNameInputId = 'student_name_input';
  static const String studentGradeInputId = 'student_grade_input';
  static const String studentDobInputId = 'student_dob_input';
  static const String studentParentNameInputId = 'student_parent_name_input';
  static const String studentParentPhoneInputId = 'student_parent_phone_input';
  static const String saveStudentBtnId = 'save_student_button';
  static const String cancelFormBtnId = 'cancel_form_button';

  static const Key studentNameInput = ValueKey(studentNameInputId);
  static const Key studentGradeInput = ValueKey(studentGradeInputId);
  static const Key studentDobInput = ValueKey(studentDobInputId);
  static const Key studentParentNameInput = ValueKey(studentParentNameInputId);
  static const Key studentParentPhoneInput = ValueKey(
    studentParentPhoneInputId,
  );
  static const Key saveStudentBtn = ValueKey(saveStudentBtnId);
  static const Key cancelFormBtn = ValueKey(cancelFormBtnId);

  // Student Detail Elements
  static const String studentDetailCardId = 'student_detail_card';
  static const String backButtonId = 'back_button';
  static const String studentNameLabelId = 'student_name_label';
  static const String studentEmailLabelId = 'student_email_label';
  static const String studentGradeLabelId = 'student_grade_label';

  static const Key studentDetailCard = ValueKey(studentDetailCardId);
  static const Key backButton = ValueKey(backButtonId);
}
