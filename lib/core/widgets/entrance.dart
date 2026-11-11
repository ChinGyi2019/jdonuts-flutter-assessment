import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

class Entrance extends StatelessWidget {
  const Entrance({
    required this.child,
    this.order = 0,
    this.offset = const Offset(0, 18),
    super.key,
  });

  final Widget child;
  final int order;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final delay = AppMotion.stagger * order;
    final total = AppMotion.entrance + delay;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: reducedMotion ? Duration.zero : total,
      curve: Interval(delay.inMicroseconds / total.inMicroseconds, 1),
      child: child,
      builder: (_, value, child) => Opacity(
        opacity: reducedMotion ? 1 : AppMotion.entranceFade.transform(value),
        child: Transform.translate(
          offset: reducedMotion
              ? Offset.zero
              : offset * (1 - AppMotion.entranceSlide.transform(value)),
          child: child,
        ),
      ),
    );
  }
}
