import 'package:flutter/material.dart';

class AppSizes {
  static const double chipsWidth = 114.0;
  static const double chipsHeight = 44.0;
  static const double chipsRadius = 22.0;
  static const double chipsSpacing = 7.0;

  static const double imageHeigth = 112.0;
  static const double imageWidth = 123.0;
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
