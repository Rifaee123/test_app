import 'package:flutter/material.dart';

extension ResponsiveUtils on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  double adaptiveWidth(double width) => width * (screenWidth / 390);
  double adaptiveHeight(double height) => height * (screenHeight / 844);
}
