import 'package:flutter/foundation.dart';

class MarksKeys {
  static const Key marksPage = ValueKey('marksPage');
  static const Key marksList = ValueKey('marksList');
  static const Key backButton = ValueKey('marksBackButton');
  static String markItem(int index) => 'markItem_$index';
}
