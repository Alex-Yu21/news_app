import 'package:flutter/material.dart';

import 'app_text.dart';

ThemeData buildAppTheme() {
  const primary = Color(0xFF2F78FF);
  const inactive = Color(0xFFC1C1C1);

  final base = ThemeData(useMaterial3: true, fontFamily: 'Satoshi');

  return base.copyWith(
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
      selectedItemColor: primary,
      unselectedItemColor: inactive,
    ),
    chipTheme: base.chipTheme.copyWith(
      selectedColor: primary,
      backgroundColor: inactive,
    ),
    extensions: <ThemeExtension<dynamic>>[AppText.satoshi()],
  );
}
