import 'package:flutter/material.dart';

@immutable
class AppText extends ThemeExtension<AppText> {
  final TextStyle titleLg;
  final TextStyle title;
  final TextStyle subtitleLg;
  final TextStyle bodyLg;
  final TextStyle body;
  final TextStyle caption;

  const AppText({
    required this.titleLg,
    required this.title,
    required this.subtitleLg,
    required this.bodyLg,
    required this.body,
    required this.caption,
  });

  factory AppText.satoshi() => const AppText(
    titleLg: TextStyle(
      fontSize: 33,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.0,
    ),
    title: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.0,
    ),
    subtitleLg: TextStyle(
      fontSize: 27,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
    ),
    bodyLg: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
    ),
    body: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
    ),
    caption: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
    ),
  );

  @override
  AppText copyWith({
    TextStyle? titleLg,
    TextStyle? title,
    TextStyle? subtitleLg,
    TextStyle? bodyLg,
    TextStyle? body,
    TextStyle? caption,
  }) => AppText(
    titleLg: titleLg ?? this.titleLg,
    title: title ?? this.title,
    subtitleLg: subtitleLg ?? this.subtitleLg,
    bodyLg: bodyLg ?? this.bodyLg,
    body: body ?? this.body,
    caption: caption ?? this.caption,
  );

  @override
  AppText lerp(ThemeExtension<AppText>? other, double t) {
    if (other is! AppText) return this;
    return AppText(
      titleLg: TextStyle.lerp(titleLg, other.titleLg, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      subtitleLg: TextStyle.lerp(subtitleLg, other.subtitleLg, t)!,
      bodyLg: TextStyle.lerp(bodyLg, other.bodyLg, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }
}
