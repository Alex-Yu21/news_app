import 'package:flutter/material.dart';

class AppSizes {
  static const double iconM = 32.0;

  static const Radius radS = Radius.circular(16.0);
  static const double radImage = 27.0;

  static const double navBarHeight = 84.0;
  static const double navBarOuterBottom = 12.0;
  static const double padding12 = 12.0;

  static double bottomPadding(BuildContext context) {
    final inset = MediaQuery.paddingOf(context).bottom;
    return navBarHeight + navBarOuterBottom + inset + padding12;
  }
}
