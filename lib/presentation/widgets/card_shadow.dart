import 'package:flutter/material.dart';
import 'package:news_app/app/theme/app_sizes.dart';

class CardShadow extends StatelessWidget {
  const CardShadow({super.key, required this.child, BorderRadius? radius})
    : radius = radius ?? const BorderRadius.all(Radius.circular(AppSizes.radS));

  final Widget child;
  final BorderRadius radius;

  static const _shadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 6.1,
      offset: Offset(0, 3),
      spreadRadius: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: _shadow),
      child: child,
    );
  }
}
