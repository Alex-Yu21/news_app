import 'package:flutter/material.dart';

import 'app_text.dart';

ThemeData buildAppTheme() {
  const primary = Color(0xFF2F78FF);
  const inactive = Color(0xFFC1C1C1);

  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Satoshi',
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
  );

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

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      circularTrackColor: inactive,
      refreshBackgroundColor: Colors.white,
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    textSelectionTheme: const TextSelectionThemeData(cursorColor: inactive),
    extensions: <ThemeExtension<dynamic>>[AppText.satoshi()],
  );
}
