import 'package:flutter/material.dart';

class SlideUpReveal extends StatelessWidget {
  const SlideUpReveal({
    super.key,
    required this.child,
    required this.from,
    this.enabled = true,
    this.duration = const Duration(milliseconds: 420),
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;
  final double from;
  final bool enabled;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    if (!enabled || from == 0) return child;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: from, end: 0),
      duration: duration,
      curve: curve,
      child: child,
      builder: (context, dy, child) =>
          Transform.translate(offset: Offset(0, dy), child: child),
    );
  }
}
